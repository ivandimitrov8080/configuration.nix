{ config, ... }: {
  programs.swaylock = {
    enable = true;
    settings = {
      show-failed-attempts = true;
      image = config.home.homeDirectory + "/pic/bg.png";
    };
  };
}
