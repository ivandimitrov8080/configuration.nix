{ pkgs, ... }: {
  home.packages = with pkgs; [
    scripts
    tor-browser-bundle-bin
    shell_gpt
    woeusb
    ollama
    goaccess
  ];
}
