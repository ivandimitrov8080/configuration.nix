{ pkgs, lib, ... }: {
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableAutosuggestions = true;
    loginExtra = ''
      [ "$(tty)" = "/dev/tty1" ] && exec sway --unsupported-gpu
    '';
    sessionVariables = {
      PASSWORD_STORE_DIR = "$HOME/.password-store";
    };
    shellAliases = {
      GG = "git add . && git commit -m 'GG' && git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)";
      gad = "git add . && git diff --cached";
      gac = "ga && gc";
      gach = "gac -C HEAD";
      ga = "git add .";
      gc = "git commit";
      dev = "nix develop --command $SHELL";
      la = "ls -alh";
      torrent = "transmission-remote";
    };
    history = {
      expireDuplicatesFirst = true;
    };
    plugins = [
      {
        name = "zsh-powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
        file = "powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
      }
    ];
    initExtra = ''
      source "$HOME/.p10k.zsh"
    '';
  };
}
