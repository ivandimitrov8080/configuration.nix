{
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    settings = {
      sudo = {
        disabled = false;
      };
    };
  };
}
