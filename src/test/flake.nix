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
      wg = import ./wireguard { inherit pkgs configuration; };
    in
    {
      packages.${system}.default = wg.driverInteractive;
      checks.${system}.default = wg;
    };
}
