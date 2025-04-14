{
  inputs = {
    # nixpkgs
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-fork.url = "github:ivandimitrov8080/nixpkgs/fork";
    # flake-compat to use this flake in configuration.nix
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
    # manages the home
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    # for flake outputs
    parts.url = "github:hercules-ci/flake-parts";
    parts.inputs.nixpkgs-lib.follows = "nixpkgs-unstable";
    # block shitty servers
    hosts.url = "github:StevenBlack/hosts";
    hosts.inputs.nixpkgs.follows = "nixpkgs-unstable";
    # for music production
    musnix.url = "github:musnix/musnix";
    musnix.inputs.nixpkgs.follows = "nixpkgs-unstable";
    # for mailserver config
    # TODO: make this follow master later
    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/a45385de413941dc6aab2fd7c7a34b96b2bc4fc8";
    simple-nixos-mailserver.inputs.nixpkgs.follows = "nixpkgs-unstable";
    # neovim latest version
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs-unstable";
    # nvim config helper
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs-unstable";
    # for formatting
    treefmt.url = "github:numtide/treefmt-nix";
    treefmt.inputs.nixpkgs.follows = "nixpkgs-unstable";
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
