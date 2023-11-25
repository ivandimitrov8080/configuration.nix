{ pkgs, ... }: {
  home.packages = with pkgs; [
    gimp
    gnome.cheese
    pavucontrol
    libsForQt5.kdenlive
    glaxnimate
    transmission
    yewtube
    audacity
  ];
}
