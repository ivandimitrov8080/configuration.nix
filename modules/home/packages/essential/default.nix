{ pkgs, ... }: {
  home.packages = with pkgs; [
    gopass
    ffmpeg
    transmission
  ];
}
