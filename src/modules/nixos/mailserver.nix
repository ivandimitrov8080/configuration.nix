{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.snm;
in
{
  options.snm = {
    enable = mkEnableOption "snm";
    webClient = mkOption {
      type = types.bool;
      default = false;
      description = ''
        This option enables the roundcube email web client.
      '';
    };
  };
  config = mkMerge [
    (mkIf cfg.snm.enable {
      imports = [ inputs.simple-nixos-mailserver.nixosModule ];
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
      security = {
        acme = {
          acceptTerms = true;
          defaults.email = "security@idimitrov.dev";
        };
      };
      services.dovecot2.sieve.extensions = [ "fileinto" ];
    })
    (mkIf cfg.snm.webClient {
      services = {
        roundcube = {
          enable = true;
          package = mkDefault pkgs.roundcube.withPlugins (plugins: [ plugins.persistent_login ]);
          plugins = mkDefault [
            "persistent_login"
          ];
          hostName = mkDefault "${config.mailserver.fqdn}";
          extraConfig = mkDefault ''
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
            "${config.mailserver.fqdn}" = mkDefault {
              extraConfig = restrictToVpn;
            };
          };
        postgresql.enable = mkDefault true;
      };
    })
  ];
}
