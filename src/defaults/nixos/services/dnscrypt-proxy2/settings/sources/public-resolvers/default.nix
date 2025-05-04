{ lib, ... }:
let
  inherit (lib) mkDefault;
  urls = [
    "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
    "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
  ];
in
{
  services.dnscrypt-proxy2.settings.public_resolvers.urls = mkDefault urls;
  services.dnscrypt-proxy2.settings.public_resolvers.cache_file =
    "/var/lib/dnscrypt-proxy/public-resolvers.md";
  services.dnscrypt-proxy2.settings.public_resolvers.minisign_key =
    "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
}
