{ pkgs, ... }: {
  home.packages = with pkgs; [
    bemenu
    wl-clipboard
    wayland
    xwayland
    mako
    grim
    slurp
    brave
    mpv
    imv
    ripgrep
    bat
    procs
    mupdf
    gopass
    ffmpeg
    xdg-utils
    xdg-user-dirs
  ];
}
