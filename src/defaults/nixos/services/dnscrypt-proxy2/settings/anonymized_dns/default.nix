let
  routes = [
    {
      server_name = "*";
      via = [ "sdns://gQ8yMTcuMTM4LjIyMC4yNDM" ];
    }
  ];
in
{
  services.dnscrypt-proxy2.settings.anonymized_dns.routes = routes;
}
