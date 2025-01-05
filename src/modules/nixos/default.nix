{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [ pwvucontrol ];
  imports = [
    inputs.simple-nixos-mailserver.nixosModule
  ];
  mailserver = {
    enable = true;
    localDnsResolver = false;
    fqdn = "mail.idimitrov.dev";
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
          allow 192.168.69.5/32;
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
            };
          };
          extraConfig = ''
            add_header 'Referrer-Policy' 'origin-when-cross-origin';
            add_header X-Content-Type-Options nosniff;
          '';
        };
        extensions = [
          "html"
          "txt"
          "png"
          "jpg"
          "jpeg"
        ];
        serveStatic = exts: ''
          try_files ${
            pkgs.lib.strings.concatStringsSep " " (builtins.map (x: "$uri.${x}") exts)
          } $uri $uri/ =404;
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
                ${serveStatic [ "png" ]}
              '';
            };
          };
        };
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
            {
              publicKey = "IDe1MPtS46c2iNcE+VrOSUpOVGMXjqFl+XV5Z5U+DDI=";
              allowedIPs = [ "192.168.69.5/32" ];
            }
          ];
        };
    };
  };
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
  networking = {
    firewall = lib.mkForce {
      enable = true;
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
      # allow ssh and imaps for vpn
      extraCommands = ''
        iptables -N vpn  # create a new chain named vpn
        iptables -A vpn --src 192.168.69.2 -j ACCEPT  # allow
        iptables -A vpn --src 192.168.69.3 -j ACCEPT  # allow
        iptables -A vpn --src 192.168.69.4 -j ACCEPT  # allow
        iptables -A vpn --src 192.168.69.5 -j ACCEPT  # allow
        iptables -A vpn -j DROP  # drop everyone else
        iptables -I INPUT -m tcp -p tcp --dport 22 -j vpn
        iptables -I INPUT -m tcp -p tcp --dport 993 -j vpn
      '';
      extraStopCommands = ''
        iptables -F vpn
        iptables -D INPUT -m tcp -p tcp --dport 22 -j vpn
        iptables -D INPUT -m tcp -p tcp --dport 993 -j vpn
        iptables -X vpn
      '';
    };
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
