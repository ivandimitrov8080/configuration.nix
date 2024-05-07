pkgs: with pkgs; {
  dev = [
    openssh
    procs
    ripgrep
    fswatch
  ];
  essential = [
    gopass
    ffmpeg
    transmission
  ];
  random = [
    telegram-desktop
  ];
}
