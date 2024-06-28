{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    defaultKeymap = "viins";
    enableVteIntegration = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    loginExtra = ''
      [ "$(tty)" = "/dev/tty1" ] && exec sway
    '';
    sessionVariables = {
      TERM = "screen-256color";
    };
    shellAliases = {
      cal = "cal $(date +%Y)";
      GG = "git add . && git commit -m 'GG' && git push --set-upstream origin HEAD";
      gad = "git add . && git diff --cached";
      gac = "ga && gc";
      gach = "gac -C HEAD";
      ga = "git add .";
      gc = "git commit";
      dev = "nix develop --command $SHELL";
      ls = "${pkgs.nushell}/bin/nu -c 'ls'";
      la = "${pkgs.nushell}/bin/nu -c 'ls -al'";
      torrent = "transmission-remote";
      vi = "nvim";
      sc = "systemctl";
    };
    shellGlobalAliases.comp = "-vcodec libx265 -crf 28";
    history.expireDuplicatesFirst = true;
    historySubstringSearch.enable = true;
  };
}
