{ pkgs, ... }: {
  programs.nushell = {
    enable = true;
    environmentVariables = {
      config = ''
        {
          show_banner: false,
          completions: {
            quick: false
            partial: false
            algorithm: "prefix"
          }
        }
      '';
      PATH = "($env.PATH | split row (char esep) | append ($env.HOME | path join .local bin))";
    };
    shellAliases = {
      gcal = ''
        bash -c "cal $(date +%Y)"
      '';
      la = "ls -al";
      dev = "nix develop --command $env.SHELL";
      torrent = "transmission-remote";
      vi = "nvim";
      sc = "systemctl";
      neofetch = "${pkgs.fastfetch}/bin/fastfetch -c all.jsonc";
    };
    loginFile.text = ''
      if (tty) == "/dev/tty1" {
        sway
      }
    '';
  };
}
