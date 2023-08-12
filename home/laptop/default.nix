{ pkgs, lib, ... }: {

  imports = [ ./programs ./packages ];

  programs.home-manager = { enable = true; };

  home = {
    username = "ivand";
    homeDirectory = "/home/ivand";
    stateVersion = "23.05";
    sessionPath = [ "$HOME/.local/bin/" "$HOME/.local/share/pnpm" ];
    pointerCursor = {
      name = "Bibata-Modern-Amber";
      package = pkgs.bibata-cursors;
    };
    file = {
      ".local/bin/ec" = {
        text = ''
          #!/usr/bin/env bash
          emacsclient -c -a 'emacs'
        '';
        executable = true;
      };
    };
  };

  xdg.configFile = {
    "nix/nix.conf" = {
      text = ''
        experimental-features = nix-command flakes
      '';
    };
    "user-dirs.dirs" = {
      source = pkgs.writeText "user-dirs.dirs" ''
        XDG_DESKTOP_DIR="dt"
        XDG_DOCUMENTS_DIR="doc"
        XDG_DOWNLOAD_DIR="dl"
        XDG_MUSIC_DIR="snd"
        XDG_PICTURES_DIR="pic"
        XDG_PUBLICSHARE_DIR="pub"
        XDG_TEMPLATES_DIR="tp"
        XDG_VIDEOS_DIR="vid"
      '';
    };
  };
  services = { emacs = { enable = true; }; };
}
