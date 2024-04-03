{ system, pkgs, ide, ... }: {

  nvim = import ./neovim {
    nvim = ide.nvim.${system}.homeManagerModules.nvim;
  };
  bottom = import ./bottom;
  browserpass = { programs.browserpass.enable = true; };
  chromium = import ./chromium { inherit pkgs; };
  comma = import ./comma;
  firefox = import ./firefox { inherit pkgs; };
  git = import ./git;
  gpg = import ./gpg { inherit pkgs; };
  kitty = import ./kitty { inherit pkgs; };
  lf = import ./lf;
  nushell = import ./nushell;
  obs-studio = import ./obs-studio { inherit pkgs; };
  sway = import ./sway { inherit pkgs; };
  swaylock = import ./swaylock;
  tealdeer = import ./tealdeer;
  tmux = import ./tmux { inherit pkgs; };
  waybar = import ./waybar { inherit pkgs; };
  zsh = import ./zsh { inherit pkgs; };
}
