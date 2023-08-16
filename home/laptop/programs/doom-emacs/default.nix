{ pkgs, lib, ... }: {

  home.packages = with pkgs; [
    nodePackages_latest.prettier
    nodePackages_latest.typescript
    nodePackages_latest.eslint
    nodePackages_latest.typescript-language-server
    nodePackages_latest."@tailwindcss/language-server"
    nodePackages_latest."@prisma/language-server"

    ispell

    rnix-lsp
  ];

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
  };
}
