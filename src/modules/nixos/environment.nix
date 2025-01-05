{ pkgs, lib, ... }:
{
  environment = with lib; {
    systemPackages = with pkgs; [
      cmatrix
      uutils-coreutils-noprefix
      cryptsetup
      fd
      file
      glibc
      gnumake
      mlocate
      openssh
      openssl
      procs
      ripgrep
      srm
      unzip
      vim
      zip
      just
      nixos-install-tools
      tshark
    ];
    sessionVariables = {
      MAKEFLAGS = mkDefault "-j 4";
    };
    shells = with pkgs; [
      bash
      zsh
      nushell
    ];
    enableAllTerminfo = mkDefault true;
  };
}
