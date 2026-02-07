{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.meta.dnscrypt;
in
{
  options.meta.dnscrypt = {
    enable = mkEnableOption "enable dnscrypt config";
  };
  config = mkIf cfg.enable {
    networking.nameservers = [
      "10.0.0.1:5300"
    ];
    services = {
      resolved = {
        enable = true;
        settings = {
          Resolve = {
            DNSSEC = true;
            DNSOverTLS = true;
          };
        };
      };
      dnscrypt-proxy = {
        enable = true;
        settings = {
          cache = true;
          listen_addresses = [
            "10.0.0.1:5300"
          ];
        };
      };
    };
  };
}
