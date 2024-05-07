{ pkgs, home-manager, modules, nid, catppuccin, ... }:
let
  ivand-programs = with modules.home.programs; [
    bat
    bottom
    browserpass
    carapace
    chromium
    cliphist
    comma
    firefox
    git
    gpg
    imv
    kitty
    lf
    mako
    mpv
    nushell
    nvim
    obs-studio
    pueue
    rofi
    starship
    sway
    swaylock
    tealdeer
    tmux
    waybar
    zsh
  ];
  ivand-packages = {
    home.packages = with modules.home.packages; (dev ++ essential ++ random);
  };
in
{
  ivand = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [ ./ivand nid.hmModules.nix-index ivand-packages ] ++ ivand-programs ++ [ catppuccin.homeManagerModules.catppuccin ];
  };
}
