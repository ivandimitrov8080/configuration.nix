{ lib, pkgs, ... }:
with lib;
{
  services = {
    nginx =
      let
        webshiteConfig = {
          enableACME = true;
          forceSSL = true;
          locations = {
            "/" = {
              root = "${pkgs.webshite}";
              extraConfig = serveStatic extensions;
            };
            "/api" = {
              proxyPass = "http://127.0.0.1:8000";
            };
          };
          extraConfig = ''
            add_header 'Referrer-Policy' 'origin-when-cross-origin';
            add_header X-Content-Type-Options nosniff;
          '';
        };
        extensions = [
          "html"
          "txt"
          "png"
          "jpg"
          "jpeg"
        ];
        serveStatic = exts: ''
          try_files ${
            pkgs.lib.strings.concatStringsSep " " (builtins.map (x: "$uri.${x}") exts)
          } $uri $uri/ =404;
        '';
      in
      {
        recommendedGzipSettings = mkDefault true;
        recommendedOptimisation = mkDefault true;
        recommendedProxySettings = mkDefault true;
        recommendedTlsSettings = mkDefault true;
        sslCiphers = mkDefault "AES256+EECDH:AES256+EDH:!aNULL";
        virtualHosts = {
          "idimitrov.dev" = webshiteConfig;
          "www.idimitrov.dev" = webshiteConfig;
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
                ${serveStatic [ "png" ]}
              '';
            };
          };
        };
      };
  };
}
