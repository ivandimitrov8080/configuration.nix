{ pkgs, ... }: {
  home.packages = with pkgs; [
    tor-browser-bundle-bin
    firefox-devedition-bin
    shell_gpt
    woeusb
    ollama
  ];
}
