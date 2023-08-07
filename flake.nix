{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, emacs-overlay, ... }: {
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
        pkgs = import nixpkgs { system = "x86_64-linux"; overlays = [ emacs-overlay.overlay ]; };
      };
    };
  };
}

