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
  };
}
