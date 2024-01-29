{
  programs = {
    nushell = {
      enable = true;
      environmentVariables = {
        PASSWORD_STORE_DIR = "([$env.HOME, '.password-store'] | str join '/')";
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
      };
      loginFile.text = ''
        if (tty) == "/dev/tty1" {
          sway
        }
      '';
      extraConfig = ''
        $env.config = {
         show_banner: false,
         completions: {
          quick: true
          partial: true
          algorithm: "fuzzy"
         }
        }
        $env.PATH = ($env.PATH | split row (char esep) |
          append ([$env.HOME, '.local', 'bin'] | str join '/')
        )
      '';
    };
    starship = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}
