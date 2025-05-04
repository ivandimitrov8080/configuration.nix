let
  urls = [
    "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
    "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
  ];
in
{
  services.dnscrypt-proxy2.settings.sources.public-resolvers.urls = urls;
  services.dnscrypt-proxy2.settings.sources.public-resolvers.cache_file =
    "/var/lib/dnscrypt-proxy/public-resolvers.md";
  services.dnscrypt-proxy2.settings.sources.public-resolvers.minisign_key =
    "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
}
