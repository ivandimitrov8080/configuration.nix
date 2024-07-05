toplevel@{ inputs, withSystem, ... }:
let
  system = "x86_64-linux";
  nixosModules = toplevel.config.flake.nixosModules;
  minimal = [ ./nova-hardware.nix inputs.hosts.nixosModule ] ++ (with nixosModules; [ grub base sound wayland security ivand wireless wireguard ]);
in
{
  flake.nixosConfigurations = {
    nixos = withSystem system (ctx@{ config, inputs', ... }:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs inputs';
          packages = config.packages;
        };
        modules = minimal;
      });
    music = withSystem system (ctx@{ config, inputs', ... }:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs inputs';
          packages = config.packages;
        };
        modules = minimal ++ [ inputs.musnix.nixosModules.musnix ] ++ (with nixosModules; [ music ]);
      });
    vm = withSystem system (ctx@{ config, inputs', ... }:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs inputs';
          packages = config.packages;
        };
        modules = [
          inputs.hosts.nixosModule
        ] ++ (with nixosModules; [ vm base security testUser ]);
      });
  };
}
