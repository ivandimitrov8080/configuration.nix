{ pkgs, ... }: {
  home.packages = with pkgs; [
    tor-browser-bundle-bin
    shell_gpt
    woeusb
    ollama
  ];
}
