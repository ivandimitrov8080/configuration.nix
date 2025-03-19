top@{ inputs, moduleWithSystem, ... }:
{
  flake.nixosModules = {
    default = moduleWithSystem (
      _:
      { lib, ... }:
      let
        files = lib.filesystem.listFilesRecursive ./.;
        endsWith =
          e: x:
          with builtins;
          let
            se = toString e;
            sx = toString x;
          in
          (stringLength sx >= stringLength se)
          && (substring ((stringLength sx) - (stringLength se)) (stringLength sx) sx) == se;
        defaults = with builtins; (filter (x: endsWith "default.nix" x) files);
      in
      {
        imports = with builtins; filter (x: !((endsWith "nixos/default.nix" x))) defaults;
      }
    );
    flakeModule = moduleWithSystem (
      _:
      { pkgs, config, ... }:
      {
        imports = with inputs; [
          hosts.nixosModule
          home-manager.nixosModules.default
          webshite.nixosModules.default
          simple-nixos-mailserver.nixosModule
          musnix.nixosModules.musnix
        ];
        nix.registry = {
          self.flake = inputs.self;
          nixpkgs.flake = inputs.nixpkgs-unstable;
          p.flake = inputs.nixpkgs-unstable;
          stable.flake = inputs.nixpkgs-stable;
        };
        nixpkgs = {
          config = {
            allowUnfree = false;
            packageOverrides = pkgs: {
              stable = import inputs.nixpkgs-stable {
                system = pkgs.system;
                config = config.nixpkgs.config;
              };
              fork = import inputs.nixpkgs-fork {
                system = pkgs.system;
                config = config.nixpkgs.config;
              };
            };
          };
          overlays = [
            inputs.self.overlays.default
          ];
        };
        system.stateVersion = top.config.flake.stateVersion;
      }
    );
    vpsadminosModule = moduleWithSystem (
      _: _: {
        imports = with inputs; [
          vpsadminos.nixosConfigurations.container
        ];
      }
    );
    rest = moduleWithSystem (
      _:
      { pkgs, ... }:
      {
        home-manager = {
          backupFileExtension = "bak";
          useUserPackages = true;
          useGlobalPkgs = true;
          users.ivand =
            { ... }:
            {
              imports = with top.config.flake.homeManagerModules; [
                base
                ivand
                shell
                util
                swayland
                web
                reminders
              ];
            };
          users.test =
            { ... }:
            {
              imports = with top.config.flake.homeManagerModules; [
                base
                shell
                util
                swayland
                web
                reminders
                {
                  home = {
                    username = "test";
                    homeDirectory = "/home/test";
                    sessionVariables = {
                      EDITOR = "nvim";
                    };
                    packages = with pkgs; [ nvim ];
                    file = {
                      ".w3m/config".text = ''
                        inline_img_protocol 4
                        imgdisplay kitty
                        confirm_qq 0
                        extbrowser ${pkgs.firefox}/bin/firefox
                      '';
                      ".w3m/keymap".text = ''
                        keymap M EXTERN_LINK
                      '';
                    };
                  };
                }
              ];
            };
        };
        i18n.supportedLocales = [ "all" ];
        time.timeZone = "Europe/Prague";
        users.defaultUserShell = pkgs.zsh;
        systemd.network = {
          wait-online.enable = false;
        };
        environment.systemPackages = with pkgs; [ pwvucontrol ];
        users = {
          mutableUsers = false;
          users = {
            ivand = {
              isNormalUser = true;
              createHome = true;
              extraGroups = [
                "adbusers"
                "adm"
                "audio"
                "bluetooth"
                "dialout"
                "input"
                "kvm"
                "mlocate"
                "realtime"
                "render"
                "video"
                "wheel"
              ];
              hashedPassword = "$y$j9T$Wf9ljhi4c.LUoX/LJEll//$cTP..D/lBWq1PPCzaHhym8V.cibPTjy2JvRYLTf5SZ7";
            };
            test = {
              isNormalUser = true;
              createHome = true;
              extraGroups = [
                "adbusers"
                "adm"
                "audio"
                "bluetooth"
                "dialout"
                "input"
                "kvm"
                "mlocate"
                "realtime"
                "render"
                "video"
                "wheel"
              ];
              hashedPassword = "$y$j9T$SRmJu3w8Zm3iBavwpV/wi1$HLAGev7SkLvSlFki09UY6PQ90LOEO3qonmV6ZFgHCm4";
            };
          };
          extraGroups = {
            mlocate = { };
            realtime = { };
          };
        };
        fonts = {
          fontDir.enable = true;
          packages = with pkgs; [
            nerd-fonts.fira-code
            noto-fonts
            noto-fonts-emoji
            noto-fonts-lgc-plus
          ];
        };
      }
    );
  };
}
