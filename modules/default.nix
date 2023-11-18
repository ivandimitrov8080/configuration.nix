{ system, pkgs, ide, my-overlay, ... }:
{
  gaming = import ./gaming { };
  dnscrypt = import ./dnscrypt;
  packages = import ./packages { inherit pkgs; };
  programs = import ./programs { inherit pkgs; };
  nvim = import ./programs/neovim {
    nvim = ide.homeManagerModules.${system}.nvim;
  };
}
