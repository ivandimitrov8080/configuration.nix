{ pkgs, ... }: {
  home.packages = with pkgs; [
    gimp
    gnome.cheese
    pavucontrol
    fluent-reader
    libsForQt5.kdenlive
    glaxnimate
    transmission
    yewtube
  ];
}
