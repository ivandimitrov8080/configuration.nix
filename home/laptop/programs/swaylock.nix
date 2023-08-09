{ pkgs, lib, ... }: {
  programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
      line-color = "ffffff";
      show-failed-attempts = true;
    };
  };
}
