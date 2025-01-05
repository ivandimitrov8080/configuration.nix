{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    vpsadminos.url = "github:vpsfreecz/vpsadminos";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hosts = {
      url = "github:StevenBlack/hosts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    webshite = {
      url = "github:ivandimitrov8080/idimitrov.dev";
      inputs.configuration.follows = "/";
    };
  };
  outputs =
    {
      nixpkgs,
      vpsadminos,
      home-manager,
      hosts,
      musnix,
      simple-nixos-mailserver,
      neovim-nightly-overlay,
      nixvim,
      webshite,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          neovim-nightly-overlay.overlays.default
        ];
      };
    in
    {
      nixosModules = {
        default = import ./src/nixos;
      };
      homeManagerModules = {
      };
      overlays = {
      };
      templates = {
      };
    };
}
