{ system, pkgs, ide, ... }: {

  nvim = import ./neovim {
    nvim = ide.nvim.${system}.homeManagerModules.nvim;
  };
  bat = import ./bat;
  bottom = import ./bottom;
  browserpass = { programs.browserpass.enable = true; };
  carapace = import ./carapace;
  chromium = import ./chromium { inherit pkgs; };
  cliphist = import ./cliphist;
  comma = import ./comma;
  firefox = import ./firefox { inherit pkgs; };
  git = import ./git;
  gpg = import ./gpg { inherit pkgs; };
  imv = import ./imv;
  mako = import ./mako;
  kitty = import ./kitty { inherit pkgs; };
  lf = import ./lf;
  mpv = import ./mpv;
  nushell = import ./nushell { inherit pkgs; };
  obs-studio = import ./obs-studio { inherit pkgs; };
  pueue = import ./pueue;
  rofi = import ./rofi { inherit pkgs; };
  starship = import ./starship;
  sway = import ./sway { inherit pkgs; };
  swaylock = import ./swaylock;
  tealdeer = import ./tealdeer;
  tmux = import ./tmux { inherit pkgs; };
  waybar = import ./waybar;
  zsh = import ./zsh { inherit pkgs; };
}
