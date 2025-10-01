_: {
  services.nginx.recommendedGzipSettings = true;
  services.nginx.recommendedTlsSettings = true;
  services.nginx.recommendedOptimisation = true;
  services.nginx.recommendedProxySettings = true;
  services.nginx.recommendedUwsgiSettings = true;
  services.nginx.recommendedBrotliSettings = true;
  services.nginx.sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
  services.nginx.appendHttpConfig = ''
    client_body_timeout 5s;
    client_header_timeout 5s;
  '';
}
