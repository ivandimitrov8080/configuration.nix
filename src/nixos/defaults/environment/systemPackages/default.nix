{ pkgs, ... }:
let
  systemPackages = with pkgs; [
    bat
    cryptsetup
    eza
    fd
    file
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
    wget
    zip
  ];
in
{
  environment.systemPackages = systemPackages;
}
