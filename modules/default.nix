{ system, nixpkgs, pkgs, ide, ... }:
{
  gaming = import ./gaming { inherit nixpkgs; };
  dnscrypt = import ./dnscrypt;
  wireguard = import ./wireguard;
  packages = import ./packages { inherit pkgs; };
  programs = import ./programs { inherit system pkgs ide; };
}
