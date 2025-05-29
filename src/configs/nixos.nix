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
  wslConfig =
    mods:
    configWithModules {
      hardware = { };
      modules =
        (with nixosModules; [
          default
          rest
        ])
        ++ mods;
    };
in
{
  flake.nixosConfigurations = {
    nova = novaConfig [ ];
    gaming = novaConfig ([ { gaming.enable = true; } ]);
    ai = novaConfig ([ { meta.ai.enable = true; } ]);
    music = novaConfig ([ { realtimeMusic.enable = true; } ]);
    stara = staraConfig [ ];
    vps = vpsConfig ([ { webshite.enable = true; } ]);
    wsl = wslConfig ([
      {
        wsl.enable = true;
        nix.settings.ssl-cert-file = "/opt/nix-zscaler.crt";
        meta.shells.enable = true;
        meta.swayland.enable = true;
        host.name = "wsl";
        programs = {
          git.enable = true;
          gtklock.enable = true;
          zoxide.enable = true;
          zsh.enable = true;
          nix-ld.enable = true;
        };
        services = {
          pipewire.enable = true;
          dbus.enable = true;
        };
        security = {
          polkit.enable = true;
          rtkit.enable = true;
        };
      }
    ]);
  };
}
