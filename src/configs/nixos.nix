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
  wgPeers = [
    {
      PublicKey = "iRSHYRPRELX8lJ2eHdrEAwy5ZW8f5b5fOiIGhHQwKFg=";
      AllowedIPs = [
        "0.0.0.0/0"
      ];
      Endpoint = "37.205.13.29:51820";
    }
    {
      PublicKey = "rZJ7mJl0bmfWeqpUalv69c+TxukpTaxF/SN+RyxklVA=";
      AllowedIPs = [ "10.0.0.2/32" ];
    }
    {
      PublicKey = "RqTsFxFCcgYsytcDr+jfEoOA5UNxa1ZzGlpx6iuTpXY=";
      AllowedIPs = [ "10.0.0.3/32" ];
    }
    {
      PublicKey = "1e0mjluqXdLbzv681HlC9B8BfGN8sIXIw3huLyQqwXI=";
      AllowedIPs = [ "10.0.0.4/32" ];
    }
    {
      PublicKey = "IDe1MPtS46c2iNcE+VrOSUpOVGMXjqFl+XV5Z5U+DDI=";
      AllowedIPs = [ "10.0.0.5/32" ];
    }
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
      modules =
        essential
        ++ rest
        ++ mods
        ++ [
          {
            programs.gtklock.enable = true;
            media.enable = true;
            swayland.enable = true;
            grubBoot.enable = true;
            hotspots.enable = true;
            host.wgPeer = {
              enable = true;
              peers = wgPeers;
              address = "10.0.0.2/24";
            };
            services.openssh = {
              enable = true;
              settings = {
                PasswordAuthentication = false;
                PermitRootLogin = "no";
              };
            };
            users.users.ivand.openssh.authorizedKeys.keys = [
              ''
                ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICEQeXVL/PeTg4m3caOfed5GvLSGDoo/VS997ZS1vEo7 u0_a167@localhost
              ''
              ''
                ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICceRu0n7msASov3UNdutUgR7slorMsB16ZTpHJ8bv+Q ivand@nixos
              ''
            ];
            networking.firewall = {
              enable = true;
              interfaces = {
                wg0 = {
                  allowedTCPPorts = [
                    22
                    53
                    993
                  ];
                };
                wlp45s0 = {
                  allowedTCPPorts = [
                    22
                    53
                    993
                  ];
                };
              };
              allowedTCPPorts = [
                25 # smtp
                465 # smtps
                80 # http
                443 # https
              ];
              allowedUDPPorts = [
                25
                465
                80
                443
                51820 # wireguard
              ];
            };
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
            host.wgPeer = {
              peers = wgPeers;
            };
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
