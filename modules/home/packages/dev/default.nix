{ pkgs, ... }: {
  home.packages = with pkgs; [
    openssh
    procs
    ripgrep
    fswatch
  ];
}
