{ pkgs, ... }: {
  programs.gpg = {
    enable = true;
  };
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      pinentry-program ${pkgs.pinentry-bemenu}/bin/pinentry-bemenu
    '';
  };
}
