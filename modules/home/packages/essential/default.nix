{ pkgs, ... }: {
  home.packages = with pkgs; [
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
