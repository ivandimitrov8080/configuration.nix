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

  programs.emacs = {
    enable = true;
    package = with pkgs;
      (emacsPackagesFor emacs-unstable).emacsWithPackages (epkgs:
        with epkgs; [
          general
          doom-themes
          treesit-grammars.with-all-grammars
          treesit-auto
          prisma-mode
          lsp-tailwindcss
          evil
          evil-collection
          flycheck
          ivy
          ivy-rich
          counsel
	  counsel-projectile
	  magit
	  forge
	  rainbow-delimiters
          ivy-prescient
	  helpful
	  hydra
          projectile
          lsp-mode
          lsp-ui
          lsp-treemacs
          lsp-ivy
          company
          company-box
          dired-single
	  dired-open
	  bind-key
          all-the-icons
          all-the-icons-dired
	  smartparens
          no-littering
          command-log-mode
          doom-modeline
        ]);
    extraConfig = builtins.readFile ./init.el;
  };
}
