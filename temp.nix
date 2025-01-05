
  ivand = moduleWithSystem (
    _:
    { pkgs, ... }:
    let
      homeMods = top.config.flake.homeManagerModules;
    in
    {
      imports = [ inputs.home-manager.nixosModules.default ];
      home-manager = {
        backupFileExtension = "bak";
        useUserPackages = true;
        useGlobalPkgs = true;
        users.ivand =
          { ... }:
          {
            imports = with homeMods; [
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
      fonts.packages = with pkgs; [
        nerd-fonts.fira-code
        noto-fonts
        noto-fonts-emoji
        noto-fonts-lgc-plus
      ];
      users = {
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
          };
        };
        extraGroups = {
          mlocate = { };
          realtime = { };
        };
      };
      programs = {
        dconf.enable = true;
        adb.enable = true;
      };
    }
  );
