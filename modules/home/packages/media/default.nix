{ pkgs, ... }: {
  home.packages = with pkgs; [
    audacity
    ffmpeg
    gimp
    glaxnimate
    gnome.cheese
    libsForQt5.kdenlive
    mpv
    mupdf
    pavucontrol
    transmission
    xonotic
    yewtube
  ];
}
