top @ { inputs, moduleWithSystem, ... }: {
  flake.nixosModules = {
    grub = moduleWithSystem (_: { pkgs, ... }: {
      boot = {
        loader = {
          grub =
            let
              theme = pkgs.sleek-grub-theme.override {
                withBanner = "Hello Ivan";
                withStyle = "bigSur";
              };
            in
            {
              inherit theme;
              enable = pkgs.lib.mkDefault true;
              useOSProber = true;
              efiSupport = true;
              device = "nodev";
              splashImage = "${theme}/background.png";
            };
          efi.canTouchEfiVariables = true;
        };
      };
    });
    base = moduleWithSystem (_: { pkgs, ... }: {
      imports = [ inputs.hosts.nixosModule ];
      system.stateVersion = top.config.flake.stateVersion;
      nix = {
        extraOptions = ''experimental-features = nix-command flakes'';
        registry = {
          self.flake = inputs.self;
          nixpkgs.flake = inputs.nixpkgs;
          p.flake = inputs.nixpkgs;
        };
      };
      i18n.supportedLocales = [ "all" ];
      time.timeZone = "Europe/Prague";
      environment = {
        systemPackages = with pkgs; [
          cmatrix
          uutils-coreutils-noprefix
          cryptsetup
          fd
          file
          git
          glibc
          gnumake
          mlocate
          openssh
          openssl
          procs
          ripgrep
          srm
          unzip
          vim
          zip
          just
          nixos-install-tools
          tshark
          flake
        ];
        sessionVariables = {
          MAKEFLAGS = "-j 4";
        };
        shells = with pkgs; [ bash zsh nushell ];
        enableAllTerminfo = true;
      };
      users.defaultUserShell = pkgs.zsh;
      programs = {
        zsh.enable = true;
        nix-ld.enable = true;
      };
      services = {
        dbus.enable = true;
        logind = {
          killUserProcesses = true;
          powerKeyLongPress = "reboot";
        };
      };
      networking = {
        stevenBlackHosts = {
          enable = true;
          blockFakenews = true;
          blockGambling = true;
        };
      };
    });
    shell = moduleWithSystem (_: { pkgs, ... }: {
      programs = {
        starship.enable = true;
        zsh = {
          enableBashCompletion = true;
          syntaxHighlighting.enable = true;
          autosuggestions = {
            enable = true;
            strategy = [ "completion" ];
          };
          shellAliases = {
            cal = "cal $(date +%Y)";
            GG = "git add . && git commit -m 'GG' && git push --set-upstream origin HEAD";
            gad = "git add . && git diff --cached";
            gac = "ga && gc";
            ga = "git add .";
            gc = "git commit";
            dev = "nix develop --command $SHELL";
            eza = "${pkgs.eza}/bin/eza '--long' '--header' '--icons' '--smart-group' '--mounts' '--group-directories-first' '--octal-permissions' '--git'";
            ls = "eza";
            la = "eza --all -a";
            lt = "eza --git-ignore --all --tree --level=10";
            sc = "systemctl";
            neofetch = "${pkgs.fastfetch}/bin/fastfetch -c all.jsonc";
          };
        };
      };
    });
    sound = moduleWithSystem (_: { pkgs, ... }: {
      services = {
        pipewire = {
          enable = true;
          alsa.enable = true;
          pulse.enable = true;
        };
      };
      environment.systemPackages = with pkgs; [ pwvucontrol ];
    });
    music = moduleWithSystem (_: { pkgs, ... }: {
      imports = [ inputs.musnix.nixosModules.musnix ];
      environment.systemPackages = with pkgs; [ guitarix ];
      services.pipewire = {
        jack.enable = true;
        extraConfig = { jack."69-low-latency" = { "jack.properties" = { "node.latency" = "64/48000"; }; }; };
      };
      musnix = {
        enable = true;
        rtcqs.enable = true;
        soundcardPciId = "00:1f.3";
        kernel = {
          realtime = true;
          packages = pkgs.linuxPackages-rt;
        };
      };
    });
    wayland = moduleWithSystem (_: { pkgs, ... }: {
      hardware.graphics.enable = true;
      security.pam.services.swaylock = { };
      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
        config.sway.default = "wlr";
        wlr = {
          enable = true;
          settings = {
            screencast = {
              output_name = "HDMI-A-1";
              max_fps = 60;
            };
          };
        };
        config.common.default = "*";
      };
    });
    security = moduleWithSystem (_: _: {
      security = {
        sudo = {
          enable = false;
          execWheelOnly = true;
          extraRules = [{ groups = [ "wheel" ]; }];
        };
        doas = {
          enable = true;
          extraRules = [
            {
              groups = [ "wheel" ];
              noPass = true;
              keepEnv = true;
            }
          ];
        };
        polkit.enable = true;
        rtkit.enable = true;
      };
    });
    intranet = {
      networking.wg-quick.interfaces = {
        wg0 = {
          address = [ "192.168.69.2/32" ];
          privateKeyFile = "/etc/wireguard/privatekey";
          peers = [
            {
              publicKey = "5FiTLnzbgcbgQLlyVyYeESEd+2DtwM1JHCGz/32UcEU=";
              allowedIPs = [ "0.0.0.0/0" "::/0" ];
              endpoint = "37.205.13.29:51820";
              persistentKeepalive = 25;
            }
          ];
        };
      };
      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "prohibit-password";
        };
      };
    };
    wireless = {
      networking = {
        wireless = {
          enable = true;
          networks = {
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
            "ATHENS-HAWKS" = { };
            "3G" = {
              hidden = true;
            };
          };
        };
      };
    };
    ivand = moduleWithSystem (_: { pkgs, ... }:
      let
        homeMods = top.config.flake.homeManagerModules;
      in
      {
        imports = [ inputs.home-manager.nixosModules.default ];
        home-manager = {
          backupFileExtension = "bak";
          useUserPackages = true;
          useGlobalPkgs = true;
          users.ivand = { ... }: {
            imports = with homeMods; [
              base
              ivand
              shell
              util
              swayland
              web
            ];
          };
        };
        fonts.packages = with pkgs; [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) noto-fonts noto-fonts-emoji noto-fonts-lgc-plus ];
        users = {
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
            };
          };
          extraGroups = {
            mlocate = { };
            realtime = { };
          };
        };
        programs.dconf.enable = true;
      });
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
    ai = moduleWithSystem (_: _: {
      services = { ollama.enable = true; };
    });
    containers = moduleWithSystem (_: _: {
      virtualisation.docker = {
        enable = true;
        storageDriver = "btrfs";
      };
      users.users.ivand.extraGroups = [ "docker" ];
    });
    anon = moduleWithSystem (_: { pkgs, ... }: {
      environment.systemPackages = with pkgs; [ tor-browser ];
    });
    cryptocurrency = moduleWithSystem (_: { pkgs, ... }: {
      environment.systemPackages = with pkgs; [ monero-cli ];
      services = { monero.enable = true; };
    });
    monero-miner = moduleWithSystem (_: _: {
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
    });
    vps = moduleWithSystem (_: { ... }: {
      imports = [
        inputs.vpsadminos.nixosConfigurations.container
      ];
    });
    mailserver = moduleWithSystem (_: { config
                                      , pkgs
                                      , ...
                                      }: {
      imports = [
        inputs.simple-nixos-mailserver.nixosModule
      ];
      mailserver = {
        enable = true;
        localDnsResolver = false;
        fqdn = "mail.idimitrov.dev";
        domains = [ "idimitrov.dev" "mail.idimitrov.dev" ];
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
          hostName = "${config.mailserver.fqdn}";
          extraConfig = ''
            $config['smtp_host'] = "tls://${config.mailserver.fqdn}";
            $config['smtp_user'] = "%u";
            $config['smtp_pass'] = "%p";
          '';
        };
        nginx.virtualHosts =
          let
            restrictToVpn = ''
              allow 192.168.69.2/32;
              allow 192.168.69.3/32;
              allow 192.168.69.4/32;
              deny all;
            '';
          in
          {
            "${config.mailserver.fqdn}" = {
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
    });
    nginx = moduleWithSystem (_: { pkgs, ... }: {
      systemd.services.webshiteApi = {
        enable = true;
        serviceConfig = {
          ExecStart = "${pkgs.webshiteApi}/bin/api";
          Restart = "always";
        };
        wantedBy = [ "multi-user.target" ];
      };
      services = {
        nginx =
          let
            webshiteConfig = {
              enableACME = true;
              forceSSL = true;
              locations = {
                "/" = {
                  root = "${pkgs.webshite}";
                  extraConfig = serveStatic extensions;
                };
                "/api" = {
                  proxyPass = "http://127.0.0.1:8000";
                  extraConfig = ''
                    limit_req zone=one;
                  '';
                };
              };
              extraConfig = ''
                add_header 'Referrer-Policy' 'origin-when-cross-origin';
                add_header X-Content-Type-Options nosniff;
              '';
            };
            extensions = [ "html" "txt" "png" "jpg" "jpeg" ];
            serveStatic = exts: ''
              try_files ${pkgs.lib.strings.concatStringsSep " " (builtins.map (x: "$uri.${x}") exts)} $uri $uri/ =404;
            '';
          in
          {
            enable = true;
            recommendedGzipSettings = true;
            recommendedOptimisation = true;
            recommendedProxySettings = true;
            recommendedTlsSettings = true;
            sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
            virtualHosts = {
              "idimitrov.dev" = webshiteConfig;
              "www.idimitrov.dev" = webshiteConfig;
              "src.idimitrov.dev" = {
                enableACME = true;
                forceSSL = true;
                locations."/" = {
                  proxyPass = "http://127.0.0.1:3001";
                };
              };
              "pic.idimitrov.dev" = {
                enableACME = true;
                forceSSL = true;
                locations."/" = {
                  root = "/var/pic";
                  extraConfig = ''
                    autoindex on;
                    ${serveStatic ["png"]}
                  '';
                };
              };
            };
            appendHttpConfig = ''
              limit_req_zone $binary_remote_addr zone=one:50m rate=1r/m;
            '';
          };
        gitea = {
          enable = true;
          appName = "src";
          database = {
            type = "postgres";
          };
          settings = {
            server = {
              DOMAIN = "src.idimitrov.dev";
              ROOT_URL = "https://src.idimitrov.dev/";
              HTTP_PORT = 3001;
            };
            repository = {
              DEFAULT_BRANCH = "master";
            };
            service = {
              DISABLE_REGISTRATION = true;
            };
          };
        };
        postgresql = {
          enable = true;
          ensureUsers = [
            {
              name = "root";
              ensureClauses = {
                superuser = true;
                createrole = true;
                createdb = true;
              };
            }
          ];
        };
      };
    });
    wireguard-output = moduleWithSystem (_: { pkgs, ... }: {
      networking = {
        nat = {
          enable = true;
          enableIPv6 = true;
          externalInterface = "venet0";
          internalInterfaces = [ "wg0" ];
        };
        wg-quick.interfaces = {
          wg0 =
            let
              iptables = "${pkgs.iptables}/bin/iptables";
              ip6tables = "${pkgs.iptables}/bin/ip6tables";
            in
            {
              address = [ "192.168.69.1/32" ];
              listenPort = 51820;
              privateKeyFile = "/etc/wireguard/privatekey";
              postUp = ''
                ${iptables} -A FORWARD -i wg0 -j ACCEPT
                ${iptables} -t nat -A POSTROUTING -s 192.168.69.1/24 -o venet0 -j MASQUERADE
                ${ip6tables} -A FORWARD -i wg0 -j ACCEPT
                ${ip6tables} -t nat -A POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o venet0 -j MASQUERADE
              '';
              preDown = ''
                ${iptables} -D FORWARD -i wg0 -j ACCEPT
                ${iptables} -t nat -D POSTROUTING -s 192.168.69.1/24 -o venet0 -j MASQUERADE
                ${ip6tables} -D FORWARD -i wg0 -j ACCEPT
                ${ip6tables} -t nat -D POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o venet0 -j MASQUERADE
              '';
              peers = [
                {
                  publicKey = "kI93V0dVKSqX8hxMJHK5C0c1hEDPQTgPQDU8TKocVgo=";
                  allowedIPs = [ "192.168.69.2/32" ];
                }
                {
                  publicKey = "RqTsFxFCcgYsytcDr+jfEoOA5UNxa1ZzGlpx6iuTpXY=";
                  allowedIPs = [ "192.168.69.3/32" ];
                }
                {
                  publicKey = "1e0mjluqXdLbzv681HlC9B8BfGN8sIXIw3huLyQqwXI=";
                  allowedIPs = [ "192.168.69.4/32" ];
                }
              ];
            };
        };
      };
    });
    anonymous-dns = moduleWithSystem (_: _: {
      networking = {
        nameservers = [ "127.0.0.1" "::1" ];
        dhcpcd.extraConfig = "nohook resolv.conf";
      };
      services = {
        dnscrypt-proxy2 = {
          enable = true;
          settings = {
            cache = false;
            ipv4_servers = true;
            ipv6_servers = true;
            dnscrypt_servers = true;
            doh_servers = false;
            odoh_servers = false;
            require_dnssec = true;
            require_nolog = true;
            require_nofilter = true;
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
    });
    firewall = moduleWithSystem (_: { lib, ... }: {
      networking = {
        firewall = lib.mkForce {
          enable = true;
          allowedTCPPorts = [
            25 # smtp
            465 # smtps
            80 # http
            443 # https
            993 # imaps
          ];
          allowedUDPPorts = [
            25
            465
            80
            443
            51820 # wireguard
          ];
          extraCommands = ''
            iptables -N vpn  # create a new chain named vpn
            iptables -A vpn --src 192.168.69.2 -j ACCEPT  # allow
            iptables -A vpn --src 192.168.69.3 -j ACCEPT  # allow
            iptables -A vpn --src 192.168.69.4 -j ACCEPT  # allow
            iptables -A vpn -j DROP  # drop everyone else
            iptables -I INPUT -m tcp -p tcp --dport 22 -j vpn
          '';
          extraStopCommands = ''
            iptables -F vpn
            iptables -D INPUT -m tcp -p tcp --dport 22 -j vpn
            iptables -X vpn
          '';
        };
      };
    });
    rest = moduleWithSystem (_: { pkgs, ... }: {
      fileSystems."/mnt/export1981" = {
        device = "172.16.128.47:/nas/5490";
        fsType = "nfs";
        options = [ "nofail" ];
      };
      users = {
        users.ivand = {
          isNormalUser = true;
          hashedPassword = "$2b$05$hPrPcewxj4qjLCRQpKBAu.FKvKZdIVlnyn4uYsWE8lc21Jhvc9jWG";
          extraGroups = [ "wheel" "adm" "mlocate" ];
          openssh.authorizedKeys.keys = [
            ''
              ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICcLkzuCoBEg+wq/H+hkrv6pLJ8J5BejaNJVNnymlnlo ivan@idimitrov.dev
            ''
          ];
        };
        extraGroups = { mlocate = { }; };
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
    });
  };
}
