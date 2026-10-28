# The "developer machine" baseline: tooling, fonts, nix-ld, kmonad and the meta
# modules a graphical host wants. iso.nix and nova.nix used to carry a ~120 line
# copy of this each, differing only in the OPTIONS_JSON_* variables.
{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    mkDefault
    optionalAttrs
    types
    ;
  cfg = config.meta.minimal;
  kmonadCfg = config.meta.minimal.kmonad;

  defaultKmonadConfig = ''
    (defsrc
      esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  ssrq pause ins del
      grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
      tab  q    w    e    r    t    y    u    i    o    p    [    ]
      caps a    s    d    f    g    h    j    k    l    ;    '    \    ret
      lsft z    x    c    v    b    n    m    ,    .    /    rsft       pgup up   pgdn
      lctl lmet lalt           spc                 ralt rctl            left down rght
    )
    (deflayer base
      esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  ssrq pause ins del
      grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
      tab  q    w    e    r    t    y    u    i    o    p    [    ]
      caps a    s    d    f    g    h    j    k    l    ;    '    \    ret
      lsft z    x    c    v    b    n    m    ,    .    /    rsft       left up   right
      lctl lmet lalt           spc                 ralt rctl            left down rght
    )
  '';
in
{
  options.meta.minimal = {
    enable = mkEnableOption "the shared developer baseline";

    kmonad = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable the kmonad laptop keyboard remap (needs hardware.uinput).";
      };
      device = mkOption {
        type = types.str;
        default = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        description = "Keyboard device kmonad grabs.";
      };
      config = mkOption {
        type = types.lines;
        default = defaultKmonadConfig;
        description = "kmonad configuration text.";
      };
    };

    optionDocs = {
      nixos = mkOption {
        type = types.nullOr types.package;
        default = null;
        description = "Package providing share/doc/nixos/options.json, if this host wants it.";
      };
      homeManager = mkOption {
        type = types.nullOr types.package;
        default = null;
        description = "Package providing share/doc/home-manager/options.json.";
      };
    };
  };

  config = mkIf cfg.enable {
    nix = {
      settings = {
        substituters = [
          "https://nix-community.cachix.org"
          "https://cache.nixos.org/"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };

    security.sudo-rs.enable = true;

    environment = {
      systemPackages = with pkgs; [
        ffmpeg
        gcc
      ];
      wordlist.enable = true;
      variables = {
        SUDO_ASKPASS = "${pkgs.askpass}/bin/askpass";
        NIX_SUDOOPTS = "-A";
      }
      // optionalAttrs (cfg.optionDocs.nixos != null) {
        OPTIONS_JSON_NIXOS = "${cfg.optionDocs.nixos}/share/doc/nixos/options.json";
      }
      // optionalAttrs (cfg.optionDocs.homeManager != null) {
        OPTIONS_JSON_HOME_MANAGER = "${cfg.optionDocs.homeManager}/share/doc/home-manager/options.json";
      };
      etc."libinput/local-overrides.quirks".text = ''
        [KMonad Virtual Keyboard]
        MatchName=kmonad-laptop
        AttrKeyboardIntegration=internal
      '';
    };

    fonts = {
      fontDir.enable = true;
      packages = with pkgs; [
        nerd-fonts.fira-code
        nerd-fonts.symbols-only
        noto-fonts
        noto-fonts-color-emoji
        noto-fonts-lgc-plus
        emacs-all-the-icons-fonts
        inter
      ];
    };

    programs = {
      git.enable = true;
      zoxide.enable = true;
      zsh.enable = true;
      nix-ld.enable = true;
      nix-ld.libraries = with pkgs; [
        alsa-lib
        at-spi2-atk
        cairo
        cups
        dbus
        expat
        glib
        gtk3
        libgbm
        libx11
        libxcb
        libxcomposite
        libxdamage
        libxext
        libxfixes
        libxkbcommon
        libxrandr
        libxrender
        libxtst
        libxi
        freetype
        vulkan-loader
        libGL
        nspr
        nss
        pango
      ];
      ladybird.enable = true;
    };

    services = {
      pipewire.enable = true;
      dbus.enable = true;
      locate.enable = true;
      resolved.enable = true;
      guix.enable = true;
      libretranslate.enable = true;
      transmission.enable = true;
      kmonad = mkIf kmonadCfg.enable {
        enable = true;
        keyboards.laptop = {
          inherit (kmonadCfg) device;
          defcfg.enable = true;
          inherit (kmonadCfg) config;
        };
      };
    };

    hardware.uinput.enable = kmonadCfg.enable;

    meta = {
      graphicalBoot.enable = mkDefault true;
      shells.enable = mkDefault true;
      swayland.enable = mkDefault true;
    };
  };
}
