{ pkgs, lib, ... }: {

  home.packages = with pkgs; [
    nodePackages_latest.prettier
    nodePackages_latest.typescript
    nodePackages_latest.typescript-language-server
    nodePackages_latest."@tailwindcss/language-server"
    nodePackages_latest."@prisma/language-server"

    rnix-lsp
  ];

  programs.emacs = {
    enable = true;
    package = with pkgs;
      (emacsPackagesFor emacs-unstable).emacsWithPackages (epkgs:
        with epkgs; [
          treesit-grammars.with-all-grammars
          treesit-auto
          prisma-mode
        ]);
    extraConfig = ''
      (use-package treesit-auto
        :config
        (global-treesit-auto-mode))
      (use-package prisma-mode)
    '';
  };
}
