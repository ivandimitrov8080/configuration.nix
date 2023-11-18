{ system, pkgs, home-manager, modules, ... }: {
  ivand = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      ./ivand
      modules.programs
      modules.packages
      modules.nvim
    ];
  };
  vid = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      ./home/vid
      modules.programs
    ];
  };
}
