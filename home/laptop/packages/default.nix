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
    gnome.cheese
    gimp
    mpv
    imv
    transmission
    # cli utils
    ripgrep
    mupdf
    gopass
    gopass-jsonapi
    pavucontrol
    bat
    trashy
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
