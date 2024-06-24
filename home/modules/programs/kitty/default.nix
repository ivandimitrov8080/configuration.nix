{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    catppuccin.enable = true;
    font = {
      package = pkgs.fira-code;
      name = "FiraCodeNFM-Reg";
    };
    settings = {
      background_opacity = "0.96";
      cursor_shape = "beam";
    };
  };
}
