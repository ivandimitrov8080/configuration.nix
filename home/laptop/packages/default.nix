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
    transmission
    # cli utils
    direnv
    ripgrep
    mupdf
    gopass
    gopass-jsonapi
    pavucontrol
    bat
    trashy
    yewtube
    lolcat
    # programming
    sqlite
    tectonic
    ffmpeg
    nodePackages_latest.pnpm
    rustup
    poetry
    deno
    bun
    nodejs_20
    python311
    python311Packages.pip
    # misc
    piper
    xdg-utils
    xdg-user-dirs
    woeusb
  ];
}
