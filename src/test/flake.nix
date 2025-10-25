{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    configuration.url = "git+file://./../../flake.nix";
  };
  outputs =
    {
      self,
      nixpkgs,
      configuration,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      checks.${system} = {
        default = import ./wireguard { inherit pkgs configuration; };
      };
    };
}
