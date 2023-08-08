{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
  };

  outputs = { self, nixpkgs, home-manager, nix-doom-emacs, ... }: {
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
        modules = [ ./home/laptop.nix nix-doom-emacs.hmModule ];
        pkgs = import nixpkgs { system = "x86_64-linux"; };
      };
    };
  };
}

