{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.fira-code;
      name = "FiraCodeNFM-Reg";
    };
    settings = {
      enable_tab_bar = false;
      background_opacity = "0.96";
      cursor_shape = "beam";
    };
  };
}
