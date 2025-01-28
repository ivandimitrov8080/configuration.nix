{ pkgs, ... }:
{
  environment = {
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
      MAKEFLAGS = "-j 4 -B";
    };
    shells = with pkgs; [
      bash
      zsh
      nushell
    ];
    enableAllTerminfo = true;
  };
}
