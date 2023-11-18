{ system, pkgs, home-manager, modules, ... }: {
  ivand = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      ./ivand
      modules.packages
      modules.programs.nvim
      modules.programs.zsh
      modules.programs.tmux
      modules.programs.git
      modules.programs.chromium
      modules.programs.kitty
      modules.programs.lf
      modules.programs.obs-studio
      modules.programs.sway
      modules.programs.swaylock
    ];
  };
  vid = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      ./home/vid
    ];
  };
}
