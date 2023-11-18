{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hosts = {
      url = "github:StevenBlack/hosts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ide = {
      url = "github:ivandimitrov8080/flake-ide";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , hosts
    , ide
    , ...
    }:
    let
      system = "x86_64-linux";
      my-overlay = self: super: {
        scripts = (super.buildEnv { name = "scripts"; paths = [ ./. ]; });
      };
    in
    {
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hardware-configuration.nix
            ./sys/laptop
            ./modules/dnscrypt
            hosts.nixosModule
          ];
        };
      };
      homeConfigurations = {
        ivand = home-manager.lib.homeManagerConfiguration {
          modules = [
            ./home/ivand
            ./modules/programs
            ./modules/packages
            (
              import ./modules/programs/neovim
                {
                  nvim = ide.homeManagerModules.${system}.nvim;
                }
            )
          ];
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ my-overlay ];
          };
        };
        vid = home-manager.lib.homeManagerConfiguration {
          modules = [
            ./home/vid
            ./modules/programs
          ];
          pkgs = import nixpkgs {
            inherit system;
          };
        };
      };
    };
}
