{ system, pkgs, home-manager, modules, ... }: {
  ivand = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = with modules.programs; [ nvim zsh tmux git chromium kitty lf obs-studio sway swaylock browserpass ] ++ [ ./ivand modules.packages ];
  };
  vid = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = with modules.programs; [ nvim zsh tmux ] ++ [ ./vid ];
  };
}
