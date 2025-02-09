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
        imports =
          with builtins;
          filter (x: !((endsWith "nginx/default.nix" x) || (endsWith "nixos/default.nix" x))) defaults;
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
            };
          };
          overlays = [
            inputs.self.overlays.default
          ];
        };
        system.stateVersion = top.config.flake.stateVersion;
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
                "flatpak"
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
        fonts.packages = with pkgs; [
          nerd-fonts.fira-code
          noto-fonts
          noto-fonts-emoji
          noto-fonts-lgc-plus
        ];
      }
    );
    vpsadminosModule = moduleWithSystem (
      _: _: {
        imports = with inputs; [
          vpsadminos.nixosConfigurations.container
        ];
      }
    );
  };
}
