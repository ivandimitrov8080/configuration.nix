{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
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
    swhkd = {
      url = "github:ivandimitrov8080/swhkd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nid = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, hosts, ide, swhkd, nid, ... }:
    let
      system = "x86_64-linux";
      overlays = [
        (
          self: super: {
            scripts = (super.buildEnv { name = "scripts"; paths = [ ./. ]; });
            swhkd = swhkd.overlays.${system}.default;
          }
        )
      ];
      pkgs = import nixpkgs {
        inherit system overlays;
      };
      modules = import ./modules {
        inherit system nixpkgs pkgs ide;
      };
      home = import ./home {
        inherit system pkgs modules home-manager nid;
      };
      nixos = import ./nixos {
        inherit system nixpkgs modules hosts;
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
