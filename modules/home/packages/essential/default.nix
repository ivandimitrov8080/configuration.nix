{ pkgs, ... }: {
  home.packages = with pkgs; [
    scripts
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
    bottom
    procs
    mupdf
    gopass
    ffmpeg
    xdg-utils
    xdg-user-dirs
  ];
}
