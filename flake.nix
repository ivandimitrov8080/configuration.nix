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
    let system = "x86_64-linux"; in
    {
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./sys/laptop
            hosts.nixosModule
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
