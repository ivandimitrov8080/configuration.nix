{ pkgs, lib, ... }: {

  home.packages = with pkgs; [
    nodePackages_latest.prettier
    nodePackages_latest.typescript
    nodePackages_latest.typescript-language-server
    nodePackages_latest."@tailwindcss/language-server"
    nodePackages_latest."@prisma/language-server"
  ];

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
  };
}
