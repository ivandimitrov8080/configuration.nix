{ pkgs, ... }: {
  home.packages = with pkgs; [
    goaccess
    ollama
    procs
    pueue
    ripgrep
    scripts
    shell_gpt
    tor-browser-bundle-bin
    woeusb
  ];
}
