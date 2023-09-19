{
  inputs = {
    nixpkgs.url = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , ...
    }:
    let system = "x86_64-linux"; in
    {
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./sys/laptop
          ];
        };
      };
      homeConfigurations = {
        ivand = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = { rootPath = ./.; };
          modules = [
            ./home/laptop
          ];
          pkgs = import nixpkgs {
            inherit system;
          };
        };
      };
    };
}
