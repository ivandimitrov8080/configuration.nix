{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    ;
  inherit (lib.types) string listOf attrs;
  cfg = config.host.wgPeer;
in
{
  options.host.wgPeer = {
    enable = mkEnableOption "enable wg0 interface";
    privateKeyFile = mkOption {
      type = string;
      default = "/etc/systemd/network/wg0.key";
    };
    peers = mkOption {
      type = listOf attrs;
      default = [ ];
    };
    address = mkOption {
      type = string;
      default = "10.0.0.1";
    };
  };
  config = mkIf cfg.enable {
    systemd.network = {
      netdevs = {
        "10-wg0" = {
          netdevConfig = {
            Kind = "wireguard";
            Name = "wg0";
            Description = "Wireguard virtual network device (tunnel)";
          };
          wireguardConfig = {
            PrivateKeyFile = cfg.privateKeyFile;
            FirewallMark = 6969;
          };
          wireguardPeers = cfg.peers;
        };
      };
      networks.wg0 = {
        matchConfig.Name = "wg0";
        networkConfig = {
          Address = cfg.address;
          DNSDefaultRoute = true;
          DNS = "10.0.0.1";
          Domains = "~.";
        };
        routingPolicyRules = [
          {
            FirewallMark = 6969;
            InvertRule = true;
            Table = 1000;
            Priority = 10;
          }
          {
            To = "37.205.13.29/32";
            Priority = 5;
          }
        ];
        routes = [
          {
            Destination = "0.0.0.0/0";
            Table = 1000;
          }
        ];
      };
    };
  };
}
