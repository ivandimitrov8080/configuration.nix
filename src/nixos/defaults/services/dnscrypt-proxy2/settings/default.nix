{ lib, ... }:
let
  inherit (lib) mkDefault;
  routes = [
    {
      server_name = "*";
      via = [ "sdns://gQ8yMTcuMTM4LjIyMC4yNDM" ];
    }
  ];
  urls = [
    "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
    "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
  ];
in
{
  services.dnscrypt-proxy2.settings = mkDefault {
    cache = false;
    ipv4_servers = true;
    ipv6_servers = true;
    dnscrypt_servers = true;
    doh_servers = false;
    odoh_servers = false;
    require_dnssec = true;
    require_nolog = true;
    require_nofilter = true;
    listen_addresses = [ "127.0.0.1:53" ];
    anonymized_dns.routes = routes;
    sources.public-resolvers.urls = urls;
    sources.public-resolvers.cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
    sources.public-resolvers.minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
  };
}
