{ ... }: {
  imports = [
    ./bat
    ./bottom
    ./carapace
    ./chromium
    ./cliphist
    ./comma
    ./firefox
    ./git
    ./gpg
    ./imv
    ./mako
    ./kitty
    ./lf
    ./mpv
    ./nushell
    ./obs-studio
    ./pueue
    ./rofi
    ./starship
    ./sway
    ./swaylock
    ./tealdeer
    ./tmux
    ./waybar
    ./zsh
  ];
  programs.browserpass.enable = true;
}
