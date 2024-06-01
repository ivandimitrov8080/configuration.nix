{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
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
    nid = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
  };
  outputs = { nixpkgs, home-manager, hosts, ide, nid, catppuccin, ... }:
    let
      system = "x86_64-linux";
      stateVersion = "24.05";
      my-overlay = self: super: {
        scripts = (super.buildEnv { name = "scripts"; paths = [ ./. ]; });
      };
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ my-overlay ];
      };
      modules = import ./modules {
        inherit system nixpkgs pkgs ide my-overlay;
      };
      home = import ./home {
        inherit stateVersion pkgs modules home-manager nid catppuccin;
      };
      nixos = import ./nixos {
        inherit stateVersion system nixpkgs modules hosts catppuccin;
      };
    in
    {
      nixosConfigurations = {
        laptop = nixos.laptop;
      };
      homeConfigurations = {
        ivand = home.ivand;
      };
      modules = modules;
    };
}
