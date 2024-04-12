{ pkgs, ... }: {
  home.packages = with pkgs; [
    bat
    bemenu
    gopass
    grim
    libnotify
    libreoffice-qt
    mako
    slurp
    wayland
    wl-clipboard
    xdg-user-dirs
    xdg-utils
    xwayland
  ];
}
