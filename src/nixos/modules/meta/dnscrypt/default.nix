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
      "127.0.0.1"
      "::1"
    ];
    services = {
      dnscrypt-proxy2 = {
        enable = true;
        settings = {
          cache = true;
          listen_addresses = [
            "127.0.0.1:53"
            "10.0.0.1:53"
          ];
        };
      };
    };
  };
}
