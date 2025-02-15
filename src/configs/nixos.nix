toplevel@{
  inputs,
  withSystem,
  ...
}:
let
  system = "x86_64-linux";
  mods = toplevel.config.flake.nixosModules;
  inherit (toplevel.config.flake) hardwareConfigurations;
  essential = with mods; [
    flakeModule
    default
  ];
  rest = [ mods.rest ];
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
      inputs.nixpkgs-unstable.lib.nixosSystem {
        specialArgs = {
          inherit inputs inputs';
        };
        modules = [
          hardware
          { networking.hostName = hostname; }
        ] ++ modules;
      }
    );
  novaConfig =
    mods:
    configWithModules {
      hardware = hardwareConfigurations.nova;
      modules =
        essential
        ++ rest
        ++ mods
        ++ [
          {
            programs.gtklock.enable = true;
            media.enable = true;
            swayland.enable = true;
            wgClient.enable = true;
            grubBoot.enable = true;
            hotspots.enable = true;
          }
        ];
    };
  vpsConfig =
    mods:
    configWithModules {
      modules =
        essential
        ++ mods
        ++ [
          {
            services.nginx.enable = true;
            services.postgresql.enable = true;
            vps.enable = true;
            mail.enable = true;
            anonymousDns.enable = true;
          }
        ];
    };
in
{
  flake.nixosConfigurations = {
    nova = novaConfig [ ];
    gaming = novaConfig ([ { gaming.enable = true; } ]);
    ai = novaConfig ([ { ai.enable = true; } ]);
    vps = vpsConfig (
      with mods;
      [
        vpsadminosModule
        { webshite.enable = true; }
      ]
    );
  };
}
