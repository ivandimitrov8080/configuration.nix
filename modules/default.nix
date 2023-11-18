{ system, nixpkgs, ide, my-overlay, ... }:
let
  pkgs = import nixpkgs { inherit system; overlays = [ my-overlay ]; };
in
{
  gaming = import ./gaming { };
  dnscrypt = import ./dnscrypt { };
  packages = import ./packages { inherit pkgs; };
  programs = import ./programs { inherit pkgs; };
  nvim = import ./programs/neovim {
    nvim = ide.homeManagerModules.${system}.nvim;
  };
}
