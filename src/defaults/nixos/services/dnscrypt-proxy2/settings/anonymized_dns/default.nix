{ lib, ... }:
let
  inherit (lib) mkDefault;
  routes = [
    {
      server_name = "*";
      via = [ "sdns://gQ8yMTcuMTM4LjIyMC4yNDM" ];
    }
  ];
in
{
  services.dnscrypt-proxy2.settings.anonymized_dns.routes = mkDefault routes;
}
