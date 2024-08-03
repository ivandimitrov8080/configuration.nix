{ config, pkgs, ... }:
{
  services = {
    roundcube = {
      enable = true;
      package = pkgs.roundcube.withPlugins (plugins: [ plugins.persistent_login ]);
      plugins = [
        "persistent_login"
      ];
      hostName = "${config.mailserver.fqdn}";
      extraConfig = ''
        $config['smtp_host'] = "tls://${config.mailserver.fqdn}";
        $config['smtp_user'] = "%u";
        $config['smtp_pass'] = "%p";
      '';
    };
  };
}
