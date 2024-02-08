{ pkgs, ... }: {
  home.packages = with pkgs; [
    bat
    bemenu
    brave
    ffmpeg
    gopass
    grim
    imv
    libnotify
    libreoffice-qt
    mako
    mpv
    mupdf
    procs
    ripgrep
    slurp
    wayland
    wl-clipboard
    xdg-user-dirs
    xdg-utils
    xwayland
  ];
}
