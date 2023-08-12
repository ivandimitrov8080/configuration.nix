{ pkgs, ... }: {
  imports = [ ./neovim ./doom-emacs ./sway ./tmux.nix ./zsh.nix ];

  programs = {
    thunderbird = {
      enable = true;
      profiles = { ivan = { isDefault = true; }; };
    };
    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
    };
    swaylock = {
      enable = true;
      settings = {
        color = "000000";
        line-color = "ffffff";
        show-failed-attempts = true;
      };
    };
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [ wlrobs ];
    };
    kitty = {
      enable = true;
      settings = {
        enable_tab_bar = false;
        background_opacity = "0.96";
      };
    };
    git = {
      enable = true;
      userName = "Ivan Dimitrov";
      userEmail = "ivan@idimitrov.dev";
      extraConfig = {
        color.ui = "auto";
        pull.rebase = true;
      };
    };
  };
}
