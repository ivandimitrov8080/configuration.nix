top@{ inputs, moduleWithSystem, ... }:
{
  flake.nixosModules =
    let
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
      wirelessNetworks = {
        "Smart-Hostel-2.4" = {
          psk = "smarttrans.bg";
        };
        "Yohohostel2.4G" = {
          psk = "kaskamaska";
        };
        "Nomado_Guest" = {
          psk = "welcomehome";
        };
        "HostelMusala Uni" = {
          psk = "mhostelm";
        };
        "BOUTIQUE APARTMENTS" = {
          psk = "boutique26";
        };
        "Safestay" = {
          psk = "AlldayrooftopBAR";
        };
        "HOSTEL JASMIN 2" = {
          psk = "Jasmin2024";
        };
        "HOME" = {
          psk = "iloveprague";
        };
        "Vodafone-B925" = {
          psk = "7aGh3FE6pN4p4cu6";
        };
        "O2WIFIZ_EXT" = {
          psk = "iloveprague";
        };
        "KOTEKLAN_GUEST" = {
          psk = "koteklankotek";
        };
        "TP-Link_BE7A" = {
          psk = "84665461";
        };
        "Post120" = {
          psk = "9996663333";
        };
        "MOONLIGHT2019" = {
          psk = "seacrets";
        };
        "Kaiser Terrasse" = {
          psk = "Internet12";
        };
        "bumshakalaka" = {
          psk = "locomotive420";
        };
        "ATHENS-HAWKS" = { };
        "3G" = {
          hidden = true;
        };
      };
    in
    {
      default = moduleWithSystem (
        _:
        {
          lib,
          config,
          ...
        }:
        let
          inherit (import ../../lib { inherit lib; }) endsWith findDefaults;
        in
        {
          imports =
            (with builtins; filter (x: !(endsWith "nixos/default.nix" x)) (findDefaults ./.))
            ++ (with inputs; [
              hosts.nixosModule
              home-manager.nixosModules.default
              webshite.nixosModules.default
              simple-nixos-mailserver.nixosModule
              ../../defaults/nixos
            ]);
          nix.registry = {
            self.flake = inputs.self;
            nixpkgs.flake = inputs.nixpkgs;
            p.flake = inputs.nixpkgs;
          };
          nixpkgs = {
            config = {
              allowUnfree = false;
              packageOverrides = pkgs: {
                fork = import inputs.nixpkgs-fork {
                  inherit (pkgs) system;
                  inherit (config.nixpkgs) config;
                };
              };
            };
            overlays = [
              inputs.self.overlays.default
            ];
          };
          system.stateVersion = top.config.flake.stateVersion;
        }
      );
      vpsadminosModule = moduleWithSystem (
        _: _: {
          imports = with inputs; [
            vpsadminos.nixosConfigurations.container
          ];
          meta.shells.enable = true;
          meta.dnscrypt.enable = true;
          services.nginx.enable = true;
          services.postgresql.enable = true;
          vps.enable = true;
          mail.enable = true;
          host.wgPeer = {
            peers = spokes;
          };
        }
      );
      rest = moduleWithSystem (
        _:
        { pkgs, ... }:
        {
          home-manager = {
            backupFileExtension = "bak";
            useUserPackages = true;
            useGlobalPkgs = true;
            users.ivand =
              { ... }:
              {
                imports = with top.config.flake.homeManagerModules; [
                  base
                  ivand
                  shell
                  util
                  swayland
                  web
                  reminders
                ];
              };
          };
          i18n.defaultLocale = "en_US.UTF-8";
          time.timeZone = "Europe/Prague";
          users.defaultUserShell = pkgs.bash;
          systemd.network = {
            wait-online.enable = false;
          };
          environment.systemPackages = with pkgs; [ pwvucontrol ];
          users = {
            mutableUsers = false;
            users = {
              ivand = {
                isNormalUser = true;
                createHome = true;
                extraGroups = [
                  "adbusers"
                  "adm"
                  "audio"
                  "bluetooth"
                  "dialout"
                  "input"
                  "kvm"
                  "mlocate"
                  "realtime"
                  "render"
                  "video"
                  "wheel"
                ];
                hashedPassword = "$y$j9T$Wf9ljhi4c.LUoX/LJEll//$cTP..D/lBWq1PPCzaHhym8V.cibPTjy2JvRYLTf5SZ7";
              };
            };
            extraGroups = {
              mlocate = { };
              realtime = { };
            };
          };
          fonts = {
            fontDir.enable = true;
            packages = with pkgs; [
              nerd-fonts.fira-code
              noto-fonts
              noto-fonts-emoji
              noto-fonts-lgc-plus
            ];
          };
        }
      );
      nova = moduleWithSystem (
        _:
        { pkgs, ... }:
        {
          boot.loader.systemd-boot.enable = true;
          meta.graphicalBoot.enable = true;
          meta.shells.enable = true;
          meta.swayland.enable = true;
          host.wgPeer = {
            enable = true;
            peers = hub;
            address = "10.0.0.2/24";
          };
          host.name = "nova";
          networking = {
            hosts = {
              "10.0.0.1" = [
                "ai.idimitrov.dev"
                "git.idimitrov.dev"
                "idimitrov.dev"
                "mail.idimitrov.dev"
              ];
              "10.0.0.4" = [
                "stara.idimitrov.dev"
              ];
            };
            wireless = {
              enable = true;
              networks = wirelessNetworks;
            };
          };
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
            sudo = {
              extraRules = [
                {
                  groups = [ "wheel" ];
                  commands = [
                    {
                      command = "${pkgs.brightnessctl}/bin/brightnessctl";
                      options = [ "NOPASSWD" ];
                    }
                  ];
                }
              ];
            };
            polkit.enable = true;
            rtkit.enable = true;
          };
        }
      );
      stara = moduleWithSystem (
        _: _: {
          programs = {
            git.enable = true;
            gtklock.enable = true;
            zoxide.enable = true;
            zsh.enable = true;
            nix-ld.enable = true;
          };
          networking = {
            hosts = {
              "10.0.0.1" = [
                "ai.idimitrov.dev"
                "git.idimitrov.dev"
                "idimitrov.dev"
                "mail.idimitrov.dev"
              ];
              "10.0.0.4" = [
                "stara.idimitrov.dev"
              ];
            };
            wireless = {
              enable = true;
              networks = wirelessNetworks;
            };
          };
          boot.loader.grub.enable = true;
          meta.shells.enable = true;
          meta.swayland.enable = true;
          host.wgPeer = {
            enable = true;
            peers = hub;
            address = "10.0.0.4/24";
          };
          host.name = "stara";
          services = {
            openssh = {
              enable = true;
              settings = {
                PasswordAuthentication = false;
                PermitRootLogin = "yes";
              };
            };
            dbus.enable = true;
          };
          users.users.ivand.openssh.authorizedKeys.keys = [
            ''
              ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICcLkzuCoBEg+wq/H+hkrv6pLJ8J5BejaNJVNnymlnlo ivan@idimitrov.dev
            ''
          ];
          users.users.root.openssh.authorizedKeys.keys = [
            ''
              ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICcLkzuCoBEg+wq/H+hkrv6pLJ8J5BejaNJVNnymlnlo ivan@idimitrov.dev
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
                  8080 # open-webui
                  11434 # ollama
                ];
                allowedUDPPorts = [
                  80
                  443
                  51820 # wireguard
                ];
              };
            };
            allowedTCPPorts = [
              8080 # open-webui
            ];
          };
          meta.ai.enable = true;
          services = {
            open-webui = {
              enable = true;
              host = "0.0.0.0";
            };
            monero = {
              enable = true;
              dataDir = "/data/var/lib/monero";
            };
          };
        }
      );
    };
}
