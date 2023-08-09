{ pkgs, lib, ... }: {
  programs.kitty = {
    enable = true;
    settings = {
      enable_tab_bar = false;
      background_opacity = "0.96";
    };
  };
}
