{ pkgs, ... }: {
  programs.gpg = {
    enable = true;
  };
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    pinentryPackage = pkgs.pinentry-qt;
  };
}
