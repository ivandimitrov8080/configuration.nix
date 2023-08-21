{ pkgs, ... }: {
  home.packages = with pkgs; [
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
    # cli utils
    direnv
    ripgrep
    mupdf
    gopass
    gopass-jsonapi
    pavucontrol
    bat
    trashy
    # programming
    nixfmt
    sqlite
    tectonic
    ffmpeg
    nodePackages_latest.pnpm
    rustup
    poetry
    lolcat
    deno
    nodejs_20
    python311
    python311Packages.pip
    # misc
    piper
    xdg-utils
    xdg-user-dirs
  ];
}
