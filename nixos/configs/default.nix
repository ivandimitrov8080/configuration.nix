toplevel@{ inputs, withSystem, ... }:
let
  system = "x86_64-linux";
in
{
  flake.nixosConfigurations = {
    nixos = withSystem system (ctx@{ config, inputs', ... }:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs inputs';
          packages = config.packages;
        };
        modules = [
          ./nova-hardware.nix
          inputs.hosts.nixosModule
          inputs.catppuccin.nixosModules.catppuccin
          inputs.musnix.nixosModules.musnix
        ] ++ (with toplevel.config.flake.nixosModules; [ grub base sound music wayland security ivand wireless wireguard style ]);
      });
    vm = withSystem system (ctx@{ config, inputs', ... }:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs inputs';
          packages = config.packages;
        };
        modules = [
          inputs.hosts.nixosModule
        ] ++ (with toplevel.config.flake.nixosModules; [ vm base security testUser ]);
      });
  };
}
