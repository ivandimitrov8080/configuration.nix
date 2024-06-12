toplevel@{ inputs, withSystem, ... }:
let
  system = "x86_64-linux";
in
{
  flake.nixosConfigurations.nixos = withSystem system (ctx@{ config, inputs', ... }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs inputs';
        packages = config.packages;
      };
      modules = [
        ./laptop-hardware.nix
        inputs.hosts.nixosModule
        inputs.catppuccin.nixosModules.catppuccin
      ] ++ (with toplevel.config.flake.nixosModules; [ wireguard catppuccin boot security xdg networking users services programs env rest ]);
    });
}
