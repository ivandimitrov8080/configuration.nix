toplevel@{
  inputs,
  withSystem,
  ...
}:
let
  system = "x86_64-linux";
  nixosModules = toplevel.config.flake.nixosModules;
  inherit (toplevel.config.flake) hardwareConfigurations;
  configWithModules =
    {
      hardware ? {
        nixpkgs.hostPlatform = system;
      },
      modules,
      hostname ? "nixos",
    }:
    withSystem system (
      { inputs', pkgs, ... }:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs inputs';
        };
        modules = [
          hardware
        ] ++ modules;
      }
    );
  novaConfig =
    mods:
    configWithModules {
      hardware = hardwareConfigurations.nova;
      modules =
        (with nixosModules; [
          default
          rest
          nova
        ])
        ++ mods;
    };
  staraConfig =
    mods:
    configWithModules {
      hardware = hardwareConfigurations.stara;
      modules =
        (with nixosModules; [
          default
          rest
          stara
        ])
        ++ mods;
    };
  vpsConfig =
    mods:
    configWithModules {
      modules =
        (with nixosModules; [
          default
          vpsadminosModule
        ])
        ++ mods;
    };
in
{
  flake.nixosConfigurations = {
    nova = novaConfig [ ];
    gaming = novaConfig ([ { gaming.enable = true; } ]);
    ai = novaConfig ([ { meta.ai.enable = true; } ]);
    stara = staraConfig [ ];
    vps = vpsConfig ([ { webshite.enable = true; } ]);
  };
}
