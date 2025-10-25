{ pkgs, ... }:
let
  systemPackages = with pkgs; [
    bat
    cryptsetup
    eza
    fd
    file
    nixos-install-tools
    openssh
    openssl
    procs
    ripgrep
    srm
    tshark
    unzip
    uutils-coreutils-noprefix
    wget
    zip
  ];
in
{
  environment.systemPackages = systemPackages;
}
