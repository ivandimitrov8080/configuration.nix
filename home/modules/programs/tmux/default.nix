{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    shell = "\${SHELL}";
    terminal = "screen-256color";
    plugins = with pkgs.tmuxPlugins; [ tilish catppuccin ];
    extraConfig = ''
      set-option -a terminal-features 'screen-256color:RGB'
    '';
  };
}
