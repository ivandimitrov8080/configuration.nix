top@{ inputs, moduleWithSystem, ... }:
{
  flake.nixosModules = {
    default = moduleWithSystem (
      _:
      {
        pkgs,
        lib,
        config,
        ...
      }:
      let
        inherit (import ../../lib { inherit lib; }) endsWith findDefaults;
      in
      {
        imports =
          (with builtins; filter (x: !((endsWith "nixos/default.nix" x))) (findDefaults ./.))
          ++ (with inputs; [
            hosts.nixosModule
            home-manager.nixosModules.default
            webshite.nixosModules.default
            simple-nixos-mailserver.nixosModule
            musnix.nixosModules.musnix
            ../../defaults/nixos
            ../../meta/nixos
          ]);
        nix.registry = {
          self.flake = inputs.self;
          nixpkgs.flake = inputs.nixpkgs;
          p.flake = inputs.nixpkgs;
        };
        nixpkgs = {
          config = {
            allowUnfree = false;
            packageOverrides = pkgs: {
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
        };
        i18n.defaultLocale = "en_US.UTF-8";
        time.timeZone = "Europe/Prague";
        users.defaultUserShell = pkgs.bash;
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
    nova = moduleWithSystem (
      _:
      { pkgs, ... }:
      let
        hub = [
          {
            PublicKey = "iRSHYRPRELX8lJ2eHdrEAwy5ZW8f5b5fOiIGhHQwKFg=";
            AllowedIPs = [
              "0.0.0.0/0"
            ];
            Endpoint = "37.205.13.29:51820";
            PersistentKeepalive = 7;
          }
        ];
      in
      {
        media.enable = true;
        swayland.enable = true;
        boot.loader.grub.enable = true;
        meta.graphicalBoot.enable = true;
        meta.shells.enable = true;
        hotspots.enable = true;
        host.wgPeer = {
          enable = true;
          peers = hub;
          address = "10.0.0.2/24";
        };
        host.name = "nova";
        programs = {
          git.enable = true;
          gtklock.enable = true;
          zoxide.enable = true;
          zsh.enable = true;
          nix-ld.enable = true;
        };
        security = {
          sudo = {
            extraRules = [
              {
                groups = [ "wheel" ];
                commands = [
                  {
                    command = "${pkgs.brightnessctl}/bin/brightnessctl";
                    options = [ "NOPASSWD" ];
                  }
                ];
              }
            ];
          };
          polkit.enable = true;
          rtkit.enable = true;
        };
      }
    );

  };
}
