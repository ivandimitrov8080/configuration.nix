{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.mail;
in
{
  options.mail = {
    enable = mkEnableOption "enable mailserver config";
  };
  config = mkIf cfg.enable {
    mailserver = {
      enable = true;
      localDnsResolver = false;
      fqdn = "idimitrov.dev";
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
        package = pkgs.stable.roundcube.withPlugins (plugins: [ plugins.persistent_login ]);
        plugins = [
          "persistent_login"
        ];
        hostName = "mail.idimitrov.dev";
        extraConfig = ''
          $config['smtp_host'] = "tls://${config.mailserver.fqdn}";
          $config['smtp_user'] = "%u";
          $config['smtp_pass'] = "%p";
        '';
      };
      nginx.virtualHosts =
        let
          restrictToVpn = ''
            allow 10.0.0.2/32;
            allow 10.0.0.3/32;
            allow 10.0.0.4/32;
            allow 10.0.0.5/32;
            deny all;
          '';
        in
        {
          "mail.idimitrov.dev" = {
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
  };
}
