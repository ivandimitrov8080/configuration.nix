{ system, pkgs, ide, ... }: {

  nvim = import ./neovim {
    nvim = ide.nvim.${system}.homeManagerModules.nvim;
  };
  git = import ./git;
  chromium = import ./chromium { inherit pkgs; };
  kitty = import ./kitty;
  lf = import ./lf;
  obs-studio = import ./obs-studio { inherit pkgs; };
  swaylock = import ./swaylock;
  tmux = import ./tmux { inherit pkgs; };
  zsh = import ./zsh { inherit pkgs; };
  browserpass = { programs.browserpass.enable = true; };
  sway = import ./sway { inherit pkgs; };
  bottom = import ./bottom;
}
