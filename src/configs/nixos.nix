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
    grub
    base
    shell
    security
    wireless
  ];
  desktop = with mods; [
    sound
    wayland
    intranet
    gaming
  ];
  configWithModules =
    {
      hardware ? {
        nixpkgs.hostPlatform = system;
      },
      modules,
    }:
    withSystem system (
      { inputs', pkgs, ... }:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs inputs' pkgs;
        };
        modules = [ hardware ] ++ modules;
      }
    );
  novaConfig =
    mods:
    configWithModules {
      hardware = hardwareConfigurations.nova;
      modules = essential ++ desktop ++ mods;
    };
in
{
  flake.nixosConfigurations = {
    nova = novaConfig [ mods.ivand ];
    nova-music = novaConfig (
      with mods;
      [
        ivand
        music
      ]
    );
    nova-crypto = novaConfig (
      with mods;
      [
        ivand
        cryptocurrency
      ]
    );
    nova-nonya = novaConfig (
      with mods;
      [
        ivand
        anon
        cryptocurrency
      ]
    );
    nova-ai = novaConfig (
      with mods;
      [
        ivand
        ai
      ]
    );
    nova-containers = novaConfig (
      with mods;
      [
        ivand
        containers
      ]
    );
    install-iso = configWithModules {
      modules = with mods; [
        grub
        base
        shell
        wireless
      ];
    };
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
    stara-miner = configWithModules { modules = essential ++ [ mods.monero-miner ]; };
  };
}
