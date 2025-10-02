{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    configuration.url = "github:ivandimitrov8080/configuration.nix";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      configuration,
      home-manager,
    }:
    {
      homeConfigurations.default = home-manager.lib.homeManagerConfiguration (
        let
          system = "x86_64-linux";
          pkgs = import nixpkgs { inherit system; };
        in
        {
          inherit pkgs;
          modules = [
            {
              imports = [ configuration.homeManagerModules.default ];
              home = {
                username = "test"; # change this
                homeDirectory = "/home/test"; # and this
              };
              programs.tmux.enable = true;
            }
          ];
        }
      );
    };
}
