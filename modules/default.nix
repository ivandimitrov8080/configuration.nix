{ system, nixpkgs, pkgs, ide, ... }:
{
  nixos = {
    gaming = import ./nixos/gaming { inherit nixpkgs; };
    nvidia = import ./nixos/nvidia { inherit nixpkgs; };
    dnscrypt = import ./nixos/dnscrypt;
    wireguard = import ./nixos/wireguard;
  };
  home = {
    packages = import ./home/packages pkgs;
    programs = import ./home/programs { inherit system pkgs ide; };
  };
}
