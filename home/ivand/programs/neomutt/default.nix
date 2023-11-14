{ pkgs, lib, ... }: {
  programs.neomutt = {
    enable = true;
    vimKeys = true;
  };
}
