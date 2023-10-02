{ pkgs, ... }: {
  imports = [ ./neovim ./sway ./tmux.nix ./zsh.nix ./lf ];

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
        cursor_shape = "beam";
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
    browserpass.enable = true;
  };
}
