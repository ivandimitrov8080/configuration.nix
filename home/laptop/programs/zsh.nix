{ pkgs, lib, ... }: {
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableAutosuggestions = true;
    loginExtra = ''
      [ "$(tty)" = "/dev/tty1" ] && exec sway
    '';
    shellAliases = {
      gad = "git add . && git diff --cached";
      gac = "ga && gc";
      gach = "gac -C HEAD";
      ga = "git add .";
      gc = "git commit";
      dev = "nix develop --command $SHELL";
      la = "ls -alh";
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
    ];
    initExtra = ''
      source "$HOME/.p10k.zsh"
    '';
  };
}
