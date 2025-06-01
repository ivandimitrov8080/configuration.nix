{
  inputs = {
    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-fork.url = "github:ivandimitrov8080/nixpkgs/fork";
    # flake-compat to use this flake in configuration.nix
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
    # ---
    # Below for extraction
    # ---
    # manages the home
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nvim config helper
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    # for mailserver config
    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
    simple-nixos-mailserver.inputs.nixpkgs.follows = "nixpkgs";
    # for flake outputs
    parts.url = "github:hercules-ci/flake-parts";
    parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    # block shitty servers
    hosts.url = "github:StevenBlack/hosts";
    hosts.inputs.nixpkgs.follows = "nixpkgs";
    # neovim latest version
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";
    # for formatting
    treefmt.url = "github:numtide/treefmt-nix";
    treefmt.inputs.nixpkgs.follows = "nixpkgs";
    # for vpsadmin - extract pls
    vpsadminos.url = "github:vpsfreecz/vpsadminos";
    # my website, for extraction into hosts config
    webshite.url = "github:ivandimitrov8080/idimitrov.dev";
    webshite.inputs.configuration.follows = "/";
  };
  outputs =
    inputs:
    inputs.parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./src
        inputs.treefmt.flakeModule
      ];
    };
}
