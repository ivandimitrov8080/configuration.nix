{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./sys/laptop
        ];
      };
    };
    homeConfigurations = {
      ivand = home-manager.lib.homeManagerConfiguration {
        modules = [ ./home/laptop.nix ];
	pkgs = import nixpkgs { system = "x86_64-linux"; };
      };
    };
  };
}

