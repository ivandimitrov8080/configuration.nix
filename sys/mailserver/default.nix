{ pkgs, ... }: {
  mailserver = {
    enable = true;
    fqdn = "mail.idimitrov.dev";
    domains = [ "idimitrov.dev" ];

    loginAccounts = {
      "ivan@idimitrov.dev" = {
        hashedPasswordFile = ./ivan.passwd;
        aliases = [ "admin@idimitrov.dev" ];
      };
      "security@idimitrov.dev" = { hashedPasswordFile = ./ivan.passwd; };
    };

    certificateScheme = "acme-nginx";
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "security@idimitrov.dev";
}
