{ config, ... }: {
  programs.swaylock = {
    enable = true;
    catppuccin.enable = true;
    settings = {
      show-failed-attempts = true;
      image = config.home.homeDirectory + "/pic/bg.png";
    };
  };
}
