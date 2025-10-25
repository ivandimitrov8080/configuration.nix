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
    mkMerge
    types
    ;
  inherit (lib.types)
    str
    listOf
    attrs
    either
    ;
  inherit (builtins)
    elemAt
    any
    filter
    split
    map
    ;
  cfg = config.meta.wireguard;
  addr = cfg.address;
  ipv4 = x: (elemAt (split "/" x) 0);
  endpoint = x: (elemAt (split ":" x) 0);
  isHub = any (x: x ? Endpoint && (any (y: (ipv4 y) == (ipv4 addr)) x.AllowedIPs)) cfg.peers;
  peers = filter (x: !(any (y: (ipv4 y) == (ipv4 addr)) x.AllowedIPs)) cfg.peers;
  endpoints = map (x: {
    To = "${endpoint x.Endpoint}/32";
    Priority = 5;
  }) (filter (x: x ? Endpoint) cfg.peers);
in
{
  options.meta.wireguard = {
    enable = mkEnableOption "enable wg0 interface";
    privateKeyFile = mkOption {
      type = either str types.path;
      default = "/etc/systemd/network/wg0.key";
    };
    address = mkOption {
      type = str;
      default = "10.0.0.1/24";
    };
    peers = mkOption {
      type = listOf attrs;
      default = [ ];
    };
  };
  config = mkIf cfg.enable (mkMerge [
    (mkIf (!isHub) {
      systemd.network = {
        netdevs."10-wg0" = {
          netdevConfig = {
            Kind = "wireguard";
            Name = "wg0";
            Description = "Wireguard virtual network device (tunnel)";
          };
          wireguardConfig = {
            PrivateKeyFile = builtins.toString cfg.privateKeyFile;
            FirewallMark = 6969;
          };
          wireguardPeers = peers;
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
              To = "192.168.0.0/8";
              Priority = 5;
            }
          ]
          ++ endpoints;
          routes = [
            {
              Destination = "0.0.0.0/0";
              Table = 1000;
            }
          ];
        };
      };
    })
    (mkIf isHub {
      systemd.network = {
        enable = true;
        netdevs = {
          "10-wg0" = {
            netdevConfig = {
              Kind = "wireguard";
              Name = "wg0";
              Description = "Wireguard virtual device (tunnel)";
            };
            wireguardConfig = {
              PrivateKeyFile = builtins.toString cfg.privateKeyFile;
              ListenPort = 51820;
            };
            wireguardPeers = peers;
          };
        };
        networks.wg0 = {
          matchConfig.Name = "wg0";
          networkConfig = {
            IPMasquerade = "both";
            Address = cfg.address;
          };
        };
      };
    })
  ]);
}
