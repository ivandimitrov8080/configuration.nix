toplevel@{
  inputs,
  withSystem,
  ...
}:
let
  system = "x86_64-linux";
  nixosModules = toplevel.config.flake.nixosModules;
  inherit (toplevel.config.flake) hardwareConfigurations;
  hub = [
    {
      PublicKey = "iRSHYRPRELX8lJ2eHdrEAwy5ZW8f5b5fOiIGhHQwKFg=";
      AllowedIPs = [
        "0.0.0.0/0"
      ];
      Endpoint = "37.205.13.29:51820";
      PersistentKeepalive = 7;
    }
  ];
  spokes = [
    {
      PublicKey = "rZJ7mJl0bmfWeqpUalv69c+TxukpTaxF/SN+RyxklVA=";
      AllowedIPs = [ "10.0.0.2/32" ];
    }
    {
      PublicKey = "RqTsFxFCcgYsytcDr+jfEoOA5UNxa1ZzGlpx6iuTpXY=";
      AllowedIPs = [ "10.0.0.3/32" ];
    }
    {
      PublicKey = "1nfOCubuMXC9ZSCvXOIBer9LZoftmXFDFIOia9jr1jY=";
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
        ])
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
              peers = hub;
              address = "10.0.0.2/24";
            };
            host.name = "nova";
          }
        ];
    };
  staraConfig =
    mods:
    configWithModules {
      hardware = hardwareConfigurations.stara;
      modules =
        (with nixosModules; [
          default
          rest
        ])
        ++ mods
        ++ [
          {
            programs.gtklock.enable = true;
            media.enable = true;
            swayland.enable = true;
            grubBoot.enable = true;
            grubBoot.libre = false;
            hotspots.enable = true;
            host.wgPeer = {
              enable = true;
              peers = hub;
              address = "10.0.0.4/24";
            };
            host.name = "stara";
            services.openssh = {
              enable = true;
              settings = {
                PasswordAuthentication = false;
                PermitRootLogin = "yes";
              };
            };
            users.users.ivand.openssh.authorizedKeys.keys = [
              ''
                ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICcLkzuCoBEg+wq/H+hkrv6pLJ8J5BejaNJVNnymlnlo ivan@idimitrov.dev
              ''
              ''
                ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICceRu0n7msASov3UNdutUgR7slorMsB16ZTpHJ8bv+Q ivand@nixos
              ''
            ];
            users.users.root.openssh.authorizedKeys.keys = [
              ''
                ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICcLkzuCoBEg+wq/H+hkrv6pLJ8J5BejaNJVNnymlnlo ivan@idimitrov.dev
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
                    80 # http
                    443 # https
                  ];
                  allowedUDPPorts = [
                    80
                    443
                    51820 # wireguard
                  ];
                };
              };
            };
          }
        ];
    };
  vpsConfig =
    mods:
    configWithModules {
      modules =
        (with nixosModules; [
          default
        ])
        ++ mods
        ++ [
          {
            services.nginx.enable = true;
            services.postgresql.enable = true;
            vps.enable = true;
            mail.enable = true;
            anonymousDns.enable = true;
            host.wgPeer = {
              peers = spokes;
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
    stara = staraConfig [ ];
    vps = vpsConfig (
      with nixosModules;
      [
        vpsadminosModule
        { webshite.enable = true; }
      ]
    );
  };
}
