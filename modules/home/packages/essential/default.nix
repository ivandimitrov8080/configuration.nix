{ pkgs, ... }: {
  home.packages = with pkgs; [
    rofi-wayland
    gopass
    grim
    libnotify
    libreoffice-qt
    mako
    scripts
    slurp
    wayland
    wl-clipboard
    xdg-user-dirs
    xdg-utils
    xwayland
  ];
}
