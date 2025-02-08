{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.anonymousDns;
in
{
  options.anonymousDns = {
    enable = mkEnableOption "enable dnscrypt config";
  };
  config = mkIf cfg.enable {
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

    #rest - meaning i didnt wanna do it now
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

  };
}
