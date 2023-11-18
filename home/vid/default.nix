{ pkgs, lib, ... }: {
  home = {
    username = "vid";
    homeDirectory = "/home/vid";
    stateVersion = "23.11";
    sessionPath = [
      "$HOME/.local/bin"
    ];
  };
}

