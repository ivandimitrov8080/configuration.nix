{ system, nixpkgs, my-overlay, home-manager, modules, ... }: {
  ivand = home-manager.lib.homeManagerConfiguration {
    modules = [
      ./ivand
      modules.programs
      modules.packages
      modules.nvim
    ];
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ my-overlay ];
    };
  };
  vid = home-manager.lib.homeManagerConfiguration {
    modules = [
      ./home/vid
      modules.programs
    ];
    pkgs = import nixpkgs {
      inherit system;
    };
  };
}
