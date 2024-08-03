toplevel@{ inputs, withSystem, ... }:
let
  system = "x86_64-linux";
  mods = toplevel.config.flake.nixosModules;
  hardwareConfigurations = toplevel.config.flake.hardwareConfigurations;
  essential = with mods; [ grub base security wireless wireguard ];
  desktop = with mods; [ sound wayland ];
  configWithModules = { hardware, modules }: withSystem system (ctx@{ config, inputs', pkgs, ... }: inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs inputs' pkgs;
      packages = config.packages;
    };
    modules = [ hardware ] ++ modules;
  });
  novaConfig = mods: configWithModules { hardware = hardwareConfigurations.nova; modules = essential ++ desktop ++ mods; };
in
{
  flake.nixosConfigurations = {
    nixos = novaConfig [ mods.ivand ];
    music = novaConfig (with mods; [ music ivand ]);
    nonya = novaConfig (with mods; [ anon cryptocurrency ivand ]);
    ai = novaConfig (with mods; [ ai ivand ]);
  };
}
