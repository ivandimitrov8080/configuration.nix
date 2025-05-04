{
  services.dnscrypt-proxy2.settings.cache = false;
  services.dnscrypt-proxy2.settings.ipv4_servers = true;
  services.dnscrypt-proxy2.settings.ipv6_servers = true;
  services.dnscrypt-proxy2.settings.dnscrypt_servers = true;
  services.dnscrypt-proxy2.settings.doh_servers = false;
  services.dnscrypt-proxy2.settings.odoh_servers = false;
  services.dnscrypt-proxy2.settings.require_dnssec = true;
  services.dnscrypt-proxy2.settings.require_nolog = true;
  services.dnscrypt-proxy2.settings.require_nofilter = true;
  services.dnscrypt-proxy2.settings.listen_addresses = [ "127.0.0.1:53" ];
}
