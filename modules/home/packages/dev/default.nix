{ pkgs, ... }: {
  home.packages = with pkgs; [
    bat
    openssh
    procs
    ripgrep
    fswatch
  ];
}
