{ config, pkgs, ... }: {
  imports = [
    (builtins.fetchTarball {
      # Pick a release version you are interested in and set its hash, e.g.
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-23.05/nixos-mailserver-nixos-23.05.tar.gz";
      # To get the sha256 of the nixos-mailserver tarball, we can use the nix-prefetch-url command:
      # release="nixos-23.05"; nix-prefetch-url "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/${release}/nixos-mailserver-${release}.tar.gz" --unpack
      sha256 = "1ngil2shzkf61qxiqw11awyl81cr7ks2kv3r3k243zz7v2xakm5c";
    })
  ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  services = {
    nginx = {
      # Use recommended settings
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      # Only allow PFS-enabled ciphers with AES256
      sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

      appendHttpConfig = ''
        # Add HSTS header with preloading to HTTPS requests.
        # Adding this header to HTTP requests is discouraged
        map $scheme $hsts_header {
            https   "max-age=31536000; includeSubdomains; preload";
        }
        add_header Strict-Transport-Security $hsts_header;

        # Enable CSP for your services.
        #add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

        # Minimize information leaked to other domains
        add_header 'Referrer-Policy' 'origin-when-cross-origin';

        # Disable embedding as a frame
        add_header X-Frame-Options DENY;

        # Prevent injection of code in other mime types (XSS Attacks)
        add_header X-Content-Type-Options nosniff;

        # This might create errors
        proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
      '';

      # Add any further config to match your needs, e.g.:
      virtualHosts =
        let
          base = locations: {
            inherit locations;

            forceSSL = true;
            enableACME = true;
          };
          proxy = port: base {
            "/".proxyPass = "http://127.0.0.1:" + toString (port) + "/";
          };
        in
        {
          "idimitrov.dev" = proxy 3000 // { default = true; };
        };
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 ];
  };

  mailserver = {
    enable = true;
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
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "security@idimitrov.dev";

  users = {
    users.ivand = {
      isNormalUser = true;
      hashedPassword =
        "$2b$05$hPrPcewxj4qjLCRQpKBAu.FKvKZdIVlnyn4uYsWE8lc21Jhvc9jWG";
      extraGroups = [ "wheel" "adm" "mlocate" ];
      openssh.authorizedKeys.keys = [
        ''
          ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCyW157tNiQdeoQsoo5AEzhyi6BvPeqEvChCxCHf3hikmFDqb6bvvlKYb9grW+fqE0HzALRwpXvPKnuUwHKPVG8HZ7NC9bT5RPMO0rFviNoxWF2PNDWG0ivPmLrQGKtCPM3aUIhSdUdlJ7ImYl34KBkUIrSmL7WlLJUvh1PtyyuVfrhpFzFxHwYwVCNO33L89lfl5PY/G9qrjlH64urt/6aWqMdHD8bZ4MHBPcnSwLMd7f0nNa0aTAJMabsfmndZhV24y7T1FUWG0dl27Q4rnpnZJWBDD1IyWIX/aN+DD6eVVWa4tRVJs6ycfw48hft0zs9zLn9mU4a2hxQ6VvfwpqZHOO8XqqOSai9Yw9Ba60iVQokQQiL91KidoSF7zD0U0szdEmylANyAntUcJ1kdu496s21IU2hjYfN/3seH5a9hBk8iPHp/eTeVUXFKh27rRWn0gc+rba1LF0BWfTjRYR7e1uvPEau0I61sNsp3lnMULdkgkZ9rap1sRM6ULlaRXM= ivand@nixos
        ''
      ];
    };
    extraGroups = { mlocate = { }; };
  };

  environment = {
    systemPackages = with pkgs; [ coreutils-full fd git vim mlocate ];
  };

}
