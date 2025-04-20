{
  services = {
    nginx = {
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
      appendHttpConfig = ''
        client_body_timeout 5s;
        client_header_timeout 5s;
      '';
      virtualHosts = {
        "pic.idimitrov.dev" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            root = "/var/pic";
            extraConfig = ''
              autoindex on;
            '';
          };
        };
        "ai.idimitrov.dev" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://10.0.0.4:8080";
            extraConfig = ''
              proxy_http_version 1.1;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
            '';
          };
        };
      };
    };
    postgresql = {
      ensureUsers = [
        {
          name = "root";
          ensureClauses = {
            superuser = true;
            createrole = true;
            createdb = true;
          };
        }
      ];
    };
  };
}
