{ pkgs, ... }:
let
  systemPackages = with pkgs; [
    bat
    cryptsetup
    deadnix
    fd
    file
    glibc
    gnumake
    mlocate
    nixos-install-tools
    openssh
    openssl
    procs
    ripgrep
    srm
    statix
    tshark
    unzip
    uutils-coreutils-noprefix
    vim
    wget
    zip
  ];
in
{
  environment.systemPackages = systemPackages;
}
