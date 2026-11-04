{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;
  cfg = config.meta.shells;
in
{
  options.meta.shells = {
    enable = mkEnableOption "enable zsh, xonsh, starship";
  };

  config = mkIf cfg.enable {
    programs = {
      starship.enable = true;
      bash.enable = true;
      nushell.enable = true;
    };
    environment = {
      systemPackages = with pkgs; [
        eza
        bat
        fd
        file
        inetutils
        nmap
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
      shellAliases = {
        eza = "eza --long --header --icons --smart-group --mounts --group-directories-first --octal-permissions --git";
        le = "eza";
        la = "eza --all -a";
        lt = "eza --git-ignore --all --tree --level=10";
      };
    };
  };
}
