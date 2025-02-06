top@{ inputs, moduleWithSystem, ... }:
{
  flake.nixosModules = {
    flakeModule = moduleWithSystem (
      _:
      { pkgs, config, ... }:
      {
        imports = with inputs; [
          hosts.nixosModule
          home-manager.nixosModules.default
        ];
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
        nix.registry = {
          self.flake = inputs.self;
          nixpkgs.flake = inputs.nixpkgs-stable;
          p.flake = inputs.nixpkgs-unstable;
        };
        nixpkgs = {
          config = {
            allowUnfree = false;
            packageOverrides = pkgs: {
              stable = import inputs.nixpkgs-stable {
                system = pkgs.system;
                config = config.nixpkgs.config;
              };
            };
          };
          overlays = [
            inputs.self.overlays.default
          ];
        };
        system.stateVersion = top.config.flake.stateVersion;
        i18n.supportedLocales = [ "all" ];
        time.timeZone = "Europe/Prague";
        users.defaultUserShell = pkgs.zsh;
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
                "flatpak"
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
        programs = {
          dconf.enable = true;
          adb.enable = true;
        };
        fonts.packages = with pkgs; [
          nerd-fonts.fira-code
          noto-fonts
          noto-fonts-emoji
          noto-fonts-lgc-plus
        ];
      }
    );
    default = moduleWithSystem (
      _:
      { lib, ... }:
      let
        files = lib.filesystem.listFilesRecursive ./.;
        endsWith =
          e: x:
          with builtins;
          let
            se = toString e;
            sx = toString x;
          in
          (stringLength sx >= stringLength se)
          && (substring ((stringLength sx) - (stringLength se)) (stringLength sx) sx) == se;
        defaults = with builtins; (filter (x: endsWith "default.nix" x) files);
      in
      {
        imports =
          with builtins;
          filter (x: !((endsWith "nginx/default.nix" x) || (endsWith "nixos/default.nix" x))) defaults;
      }
    );
    music = moduleWithSystem (
      _:
      { pkgs, ... }:
      {
        imports = [ inputs.musnix.nixosModules.musnix ];
        environment.systemPackages = with pkgs; [ guitarix ];
        services.pipewire = {
          jack.enable = true;
          extraConfig = {
            jack."69-low-latency" = {
              "jack.properties" = {
                "node.latency" = "64/48000";
              };
            };
          };
        };
        musnix = {
          enable = true;
          rtcqs.enable = true;
          soundcardPciId = "00:1f.3";
          kernel = {
            realtime = true;
            packages = pkgs.linuxPackages-rt_latest;
          };
        };
        security.pam.loginLimits = [
          {
            domain = "@users";
            item = "memlock";
            type = "-";
            value = "1048576";
          }
        ];
      }
    );
    flatpak = {
      xdg = {
        portal = {
          enable = true;
          wlr.enable = true;
          config.common.default = "*";
        };
      };
      services.flatpak.enable = true;
    };
    ai = moduleWithSystem (
      _:
      { pkgs, ... }:
      {
        boot = {
          kernelPackages = pkgs.linuxPackages_latest;
          kernelParams = [
            "amdgpu.runpm=0"
          ];
        };
        hardware.amdgpu = {
          initrd.enable = true;
          opencl.enable = true;
        };
        services = {
          ollama = {
            enable = true;
            acceleration = "rocm";
            rocmOverrideGfx = "11.0.2";
          };
        };
      }
    );
    gaming = moduleWithSystem (
      _:
      { pkgs, lib, ... }:
      {
        nixpkgs.config.allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "steam"
            "steam-original"
            "steam-unwrapped"
            "steam-run"
            "steamcmd"
          ];
        boot = {
          kernelPackages = pkgs.linuxPackages_zen;
          kernelParams = [
            "amdgpu.runpm=0"
          ];
        };
        hardware = {
          graphics.enable = true;
          amdgpu = {
            initrd.enable = true;
            amdvlk.enable = true;
          };
        };
        programs.steam = {
          enable = true;
        };
        environment.systemPackages = with pkgs; [
          xonotic
          steamcmd
        ];
      }
    );
    containers = moduleWithSystem (
      _: _: {
        virtualisation.docker = {
          enable = true;
          storageDriver = "btrfs";
        };
        users.users.ivand.extraGroups = [ "docker" ];
      }
    );
    cryptocurrency = moduleWithSystem (
      _:
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [ monero-cli ];
        services = {
          monero.enable = true;
        };
      }
    );
    monero-miner = moduleWithSystem (
      _: _: {
        services = {
          xmrig = {
            enable = true;
            settings = {
              autosave = true;
              cpu = true;
              opencl = false;
              cuda = false;
              pools = [
                {
                  url = "pool.supportxmr.com:443";
                  user = "48e9t9xvq4M4HBWomz6whiY624YRCPwgJ7LPXngcc8pUHk6hCuR3k6ENpLGDAhPEHWaju8Z4btxkbENpcwaqWcBvLxyh5cn";
                  keepalive = true;
                  tls = true;
                }
              ];
            };
          };
        };
      }
    );
    vps = moduleWithSystem (
      _:
      { ... }:
      {
        nixpkgs.hostPlatform = "x86_64-linux";
        imports = [
          inputs.vpsadminos.nixosConfigurations.container
          inputs.webshite.nixosModules.default
        ];
      }
    );
    mailserver = moduleWithSystem (
      _:
      {
        config,
        pkgs,
        ...
      }:
      {
        imports = [
          inputs.simple-nixos-mailserver.nixosModule
        ];
        mailserver = {
          enable = true;
          localDnsResolver = false;
          fqdn = "idimitrov.dev";
          domains = [
            "idimitrov.dev"
            "mail.idimitrov.dev"
          ];
          loginAccounts = {
            "ivan@idimitrov.dev" = {
              hashedPassword = "$2b$05$rTVIQD98ogXeCBKdk/YufulWHqpMCAlb7SHDPlh5y8Xbukoa/uQLm";
              aliases = [ "admin@idimitrov.dev" ];
            };
            "security@idimitrov.dev" = {
              hashedPassword = "$2b$05$rTVIQD98ogXeCBKdk/YufulWHqpMCAlb7SHDPlh5y8Xbukoa/uQLm";
            };
          };
          certificateScheme = "acme-nginx";
          hierarchySeparator = "/";
        };
        services = {
          dovecot2.sieve.extensions = [ "fileinto" ];
          roundcube = {
            enable = true;
            package = pkgs.roundcube.withPlugins (plugins: [ plugins.persistent_login ]);
            plugins = [
              "persistent_login"
            ];
            hostName = "mail.idimitrov.dev";
            extraConfig = ''
              $config['smtp_host'] = "tls://${config.mailserver.fqdn}";
              $config['smtp_user'] = "%u";
              $config['smtp_pass'] = "%p";
            '';
          };
          nginx.virtualHosts =
            let
              restrictToVpn = ''
                allow 10.0.0.2/32;
                allow 10.0.0.3/32;
                allow 10.0.0.4/32;
                allow 10.0.0.5/32;
                deny all;
              '';
            in
            {
              "mail.idimitrov.dev" = {
                extraConfig = restrictToVpn;
              };
            };
          postgresql.enable = true;
        };
        security = {
          acme = {
            acceptTerms = true;
            defaults.email = "security@idimitrov.dev";
          };
        };
      }
    );
    nginx = moduleWithSystem (
      _: _: {
        imports = [ ./services/nginx ];
      }
    );
    anonymous-dns = moduleWithSystem (
      _: _: {
        networking = {
          nameservers = [
            "127.0.0.1"
            "::1"
          ];
          dhcpcd.extraConfig = "nohook resolv.conf";
        };
        services = {
          dnscrypt-proxy2 = {
            enable = true;
            settings = {
              cache = true;
              ipv4_servers = true;
              ipv6_servers = true;
              dnscrypt_servers = true;
              doh_servers = false;
              odoh_servers = false;
              require_dnssec = true;
              require_nolog = true;
              require_nofilter = true;
              listen_addresses = [
                "127.0.0.1:53"
                "10.0.0.1:53"
              ];
              anonymized_dns = {
                routes = [
                  {
                    server_name = "*";
                    via = [ "sdns://gQ8yMTcuMTM4LjIyMC4yNDM" ];
                  }
                ];
              };
              sources.public-resolvers = {
                urls = [
                  "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
                  "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
                ];
                cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
                minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
              };
            };
          };
        };
      }
    );
    firewall = moduleWithSystem (
      _:
      { lib, ... }:
      {
        networking = {
          firewall = with lib; {
            enable = true;
            allowedTCPPorts = mkForce [
              25 # smtp
              465 # smtps
              80 # http
              443 # https
            ];
            allowedUDPPorts = mkForce [
              25
              465
              80
              443
              51820 # wireguard
            ];
          };
        };
      }
    );
    rest = moduleWithSystem (
      _:
      { pkgs, ... }:
      {
        fileSystems."/mnt/export1981" = {
          device = "172.16.128.47:/nas/5490";
          fsType = "nfs";
          options = [ "nofail" ];
        };
        users = {
          users.ivand = {
            isNormalUser = true;
            hashedPassword = "$2b$05$hPrPcewxj4qjLCRQpKBAu.FKvKZdIVlnyn4uYsWE8lc21Jhvc9jWG";
            extraGroups = [
              "wheel"
              "adm"
              "mlocate"
            ];
            openssh.authorizedKeys.keys = [
              ''
                ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICcLkzuCoBEg+wq/H+hkrv6pLJ8J5BejaNJVNnymlnlo ivan@idimitrov.dev
              ''
            ];
          };
          extraGroups = {
            mlocate = { };
          };
        };
        services = {
          openssh = {
            enable = true;
            settings = {
              PermitRootLogin = "prohibit-password";
            };
          };
        };
        systemd = {
          timers = {
            bingwp = {
              wantedBy = [ "timers.target" ];
              timerConfig = {
                OnCalendar = "*-*-* 10:00:00";
                Persistent = true;
              };
            };
          };
          services = {
            bingwp = {
              description = "Download bing image of the day";
              script = ''
                ${pkgs.nushell}/bin/nu -c "http get ('https://bing.com' + ((http get https://www.bing.com/HPImageArchive.aspx?format=js&n=1).images.0.url)) | save  ('/var/pic' | path join ( [ (date now | format date '%Y-%m-%d'), '.jpeg' ] | str join ))"
                ${pkgs.nushell}/bin/nu -c "${pkgs.toybox}/bin/ln -sf (ls /var/pic | where type == file | get name | sort | last) /var/pic/latest.jpeg"
              '';
            };
          };
        };
      }
    );
  };
}
