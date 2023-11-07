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
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , hosts
    , ...
    }:
    let
      system = "x86_64-linux";
      my-overlay = self: super: {
        scripts = (super.buildEnv { name = "scripts"; paths = [ ./scripts ]; });
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
            # ./modules/gaming
          ];
        };
      };
      homeConfigurations = {
        ivand = home-manager.lib.homeManagerConfiguration {
          modules = [
            ./home/laptop
          ];
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ my-overlay ];
          };
        };
      };
    };
}
