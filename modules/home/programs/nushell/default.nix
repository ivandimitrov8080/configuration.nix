{
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
      PASSWORD_STORE_DIR = "($env.HOME | path join .password-store)";
      PATH = "($env.PATH | split row (char esep) | append ($env.HOME | path join .local bin))";
      EDITOR = "nvim";
    };
    shellAliases = {
      gcal = ''
        bash -c "cal $(date +%Y)"
      '';
      la = "ls -al";
      ssh = "TERM=xterm-256color ssh";
      dev = "nix develop --command $env.SHELL";
      torrent = "transmission-remote";
      vi = "nvim";
      sc = "systemctl";
    };
    loginFile.text = ''
      if (tty) == "/dev/tty1" {
        sway
      }
    '';
  };
}
