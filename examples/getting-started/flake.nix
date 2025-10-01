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
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        modules =
          let
            system = "x86_64-linux";
          in
          [
            {
              imports = [
                configuration.nixosModules.default
                home-manager.nixosModules.default
              ];

              nixpkgs.hostPlatform = system;
              meta.shells.enable = true;
              users.users.test = {
                isNormalUser = true;
                createHome = true;
                password = "test";
                extraGroups = [ "wheel" ];
              };
            }
          ];
      };
    };
}
