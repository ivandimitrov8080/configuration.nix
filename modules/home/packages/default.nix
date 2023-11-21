{ pkgs, ... }: {
  home.packages = with pkgs; [
    scripts
    # wayland/sway stuff
    bemenu
    wl-clipboard
    wayland
    xwayland
    mako
    grim
    slurp
    # programs
    brave
    firefox-devedition-bin
    tor-browser-bundle-bin
    libreoffice-qt
    gimp
    mpv
    imv
    gnome.cheese
    pavucontrol
    fluent-reader
    libsForQt5.kdenlive
    glaxnimate
    # cli utils
    ripgrep
    bat
    bottom
    procs
    lolcat
    shell_gpt
    mupdf
    gopass
    transmission
    yewtube
    ffmpeg
    # AI
    ollama
    # misc
    piper
    xdg-utils
    xdg-user-dirs
    woeusb
    # games
    minetest
  ];
}
