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
      modules = essential ++ mods;
    };
in
{
  flake.nixosConfigurations = {
    nova = novaConfig [ ];
    gaming = novaConfig ([ { gaming.enable = true; } ]);
    nova-ai = novaConfig (
      with mods;
      [
        ivand
        ai
      ]
    );
    vps = configWithModules {
      modules = with mods; [
        base
        shell
        security
        vps
        mailserver
        nginx
        wireguard-output
        anonymous-dns
        firewall
        rest
      ];
    };
  };
}
