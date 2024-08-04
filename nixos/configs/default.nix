toplevel@{ inputs, withSystem, ... }:
let
  system = "x86_64-linux";
  mods = toplevel.config.flake.nixosModules;
  hardwareConfigurations = toplevel.config.flake.hardwareConfigurations;
  essential = with mods; [ grub base shell security wireless wireguard ];
  desktop = with mods; [ sound wayland ];
  configWithModules = { hardware ? { nixpkgs.hostPlatform = system; }, modules }: withSystem system (ctx@{ config, inputs', pkgs, ... }: inputs.nixpkgs.lib.nixosSystem {
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
    nova = novaConfig [ mods.ivand ];
    nova-music = novaConfig (with mods; [ music ivand ]);
    nova-nonya = novaConfig (with mods; [ anon cryptocurrency ivand ]);
    nova-ai = novaConfig (with mods; [ ai ivand ]);
    installer-iso = configWithModules { modules = (with mods; [ grub base shell wireless ]); };
    vps = configWithModules { modules = (with mods; [ base shell security vps ]); };
  };
}
