{ pkgs, lib, ... }: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    plugins = with pkgs.tmuxPlugins; [ tilish catppuccin ];
    extraConfig = ''
      set -g default-command "''${SHELL}"
      set -g default-terminal "tmux-256color"
      set -g base-index 1
      set -s escape-time 0
    '';
  };
}
