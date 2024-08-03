{ config, pkgs, ... }:
let
  webshiteConfig = ''
    add_header 'Referrer-Policy' 'origin-when-cross-origin';
    add_header X-Content-Type-Options nosniff;
    add_header Onion-Location http://sxfx23zafag4lixkb4s6zwih7ga5jnzfgtgykcerd354bvb6u7alnkid.onion;
  '';
  restrictToVpn = ''
    allow 10.0.0.2/32;
    allow fdc9:281f:04d7:9ee9::2/128;
    allow 10.0.0.3/32;
    allow 10.0.0.4/32;
    deny all;
  '';
  extensions = [ "html" "txt" "png" "jpg" "jpeg" ];
  serveStatic = exts: ''
    try_files $uri $uri/ ${pkgs.lib.strings.concatStringsSep " " (builtins.map (x: "$uri." + "${x}") exts)} =404;
  '';
in
{
  services = {
    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
      virtualHosts = {
        "idimitrov.dev" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            root = "${pkgs.webshite}";
            extraConfig = serveStatic extensions;
          };
          extraConfig = webshiteConfig;
        };
        "www.idimitrov.dev" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            root = "${pkgs.webshite}";
            extraConfig = serveStatic extensions;
          };
          extraConfig = webshiteConfig;
        };
        "${config.mailserver.fqdn}" = {
          extraConfig = restrictToVpn;
        };
        "src.idimitrov.dev" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:3001";
          };
        };
        "pic.idimitrov.dev" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            root = "/var/pic";
            extraConfig = ''
              autoindex on;
              ${serveStatic ["png"]}
            '';
          };
        };
      };
    };
  };
}
