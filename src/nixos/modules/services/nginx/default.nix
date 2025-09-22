{
  services = {
    nginx = {
      appendHttpConfig = ''
        client_body_timeout 5s;
        client_header_timeout 5s;
      '';
      virtualHosts = {
        "src.idimitrov.dev" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:9418";
            extraConfig = ''
              allow 10.0.0.0/8;
              allow 192.168.0.0/8;
              deny all;
              proxy_http_version 1.1;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
            '';
          };
        };
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
              allow 10.0.0.0/8;
              allow 192.168.0.0/8;
              deny all;
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
