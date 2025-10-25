{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    configuration.url = "git+file://./../../..";
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
      packages.${system}.default = (import ./wireguard { inherit pkgs configuration; }).driverInteractive;
      checks.${system}.default = import ./wireguard { inherit pkgs configuration; };
    };
}
