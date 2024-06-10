{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    hosts = {
      url = "github:StevenBlack/hosts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ide = {
      url = "github:ivandimitrov8080/flake-ide";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nid = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
  };
  outputs = inputs@{ parts, nixpkgs, ide, nid, home-manager, hosts, catppuccin, ... }:
    parts.lib.mkFlake { inherit inputs; } {
      flake =
        let
          stateVersion = "24.05";
          my-overlay = self: super: {
            scripts = (super.buildEnv { name = "scripts"; paths = [ ./. ]; });
          };
          pkgs = import nixpkgs {
            overlays = [ my-overlay ];
          };
          modules = import ./modules {
            inherit nixpkgs pkgs ide my-overlay;
            system = "x86_64-linux";
          };
          home = import ./home {
            inherit stateVersion pkgs modules home-manager nid catppuccin;
            system = "x86_64-linux";
          };
          nixos = import ./nixos {
            inherit stateVersion nixpkgs modules hosts catppuccin;
            system = "x86_64-linux";
          };
        in
        {
          nixosConfigurations = {
            nixos = nixos.laptop;
          };
          homeConfigurations = {
            ivand = home.ivand;
          };
          modules = modules;
        };
      systems = [
        "x86_64-linux"
      ];
      perSystem = { config, ... }: { };
    };
}
