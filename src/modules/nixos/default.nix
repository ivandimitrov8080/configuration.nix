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
  };
}
