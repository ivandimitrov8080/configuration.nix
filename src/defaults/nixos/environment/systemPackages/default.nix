{ pkgs, lib, ... }:
let
  inherit (lib) mkDefault;
  systemPackages = with pkgs; [
    bat
    cryptsetup
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
    tshark
    unzip
    uutils-coreutils-noprefix
    vim
    zip
  ];
in
{
  environment.systemPackages = mkDefault systemPackages;
}
