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
