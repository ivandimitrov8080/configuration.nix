{ system, pkgs, home-manager, modules, nid, ... }:
let
  ivand-programs = with modules.home.programs; [
    bottom
    browserpass
    carapace
    chromium
    cliphist
    comma
    firefox
    git
    gpg
    kitty
    lf
    nushell
    nvim
    obs-studio
    pueue
    starship
    sway
    swaylock
    tealdeer
    tmux
    waybar
    zsh
  ];
  ivand-packages = with modules.home.packages; [
    dev
    essential
    media
  ];
in
{
  ivand = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [ ./ivand nid.hmModules.nix-index ] ++ ivand-programs ++ ivand-packages;
  };
}
