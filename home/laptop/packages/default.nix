{ pkgs, rootPath, ... }: {
  home.packages = with pkgs; [
    #scripts
    (pkgs.buildEnv { name = "my-scripts"; paths = [ (rootPath + /scripts) ]; })
    # wayland/sway stuff
    bemenu
    wl-clipboard
    wayland
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
    # cli utils
    ripgrep
    mupdf
    gopass
    pavucontrol
    bat
    transmission
    yewtube
    lolcat
    ffmpeg
    # misc
    piper
    xdg-utils
    xdg-user-dirs
    woeusb
  ];
}
