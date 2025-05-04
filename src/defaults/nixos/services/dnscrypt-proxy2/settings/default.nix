{ lib, pkgs, ... }:
let
  inherit (lib) mkDefault;
in
{
  services.dnscrypt-proxy2.settings.cache = mkDefault false;
  services.dnscrypt-proxy2.settings.ipv4_servers = mkDefault true;
  services.dnscrypt-proxy2.settings.ipv6_servers = mkDefault true;
  services.dnscrypt-proxy2.settings.dnscrypt_servers = mkDefault true;
  services.dnscrypt-proxy2.settings.doh_servers = mkDefault false;
  services.dnscrypt-proxy2.settings.odoh_servers = mkDefault false;
  services.dnscrypt-proxy2.settings.require_dnssec = mkDefault true;
  services.dnscrypt-proxy2.settings.require_nolog = mkDefault true;
  services.dnscrypt-proxy2.settings.require_nofilter = mkDefault true;
  services.dnscrypt-proxy2.settings.listen_addresses = mkDefault [ "127.0.0.1:53" ];
}
