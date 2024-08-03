{ config, pkgs, ... }:
{
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
  services.dovecot2.sieve.extensions = [ "fileinto" ];
}
