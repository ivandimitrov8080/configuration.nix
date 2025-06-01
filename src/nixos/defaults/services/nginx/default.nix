{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  services.nginx.recommendedGzipSettings = mkDefault true;
  services.nginx.recommendedTlsSettings = mkDefault true;
  services.nginx.recommendedOptimisation = mkDefault true;
  services.nginx.recommendedZstdSettings = mkDefault true;
  services.nginx.recommendedProxySettings = mkDefault true;
  services.nginx.recommendedUwsgiSettings = mkDefault true;
  services.nginx.recommendedBrotliSettings = mkDefault true;
  services.nginx.sslCiphers = mkDefault "AES256+EECDH:AES256+EDH:!aNULL";
}
