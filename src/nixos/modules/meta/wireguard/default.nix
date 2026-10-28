# Wireguard mesh. Peers are host data (public keys, addresses, endpoints) and
# live next to the host that needs them; everything derived from them
# (AllowedIPs, Endpoint/PersistentKeepalive, hub vs. spoke layout) is computed
# here. DNS wiring is owned by meta.dns, not by this module.
{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkMerge
    mkEnableOption
    mkOption
    optionalAttrs
    mapAttrsToList
    filter
    elemAt
    split
    types
    ;
  cfg = config.meta.wireguard;

  rmPort = x: elemAt (split ":" x) 0;

  peers = mapAttrsToList (name: peer: peer // { inherit name; }) cfg.peers;
  me = cfg.peers.${cfg.self} or null;
  isHub = me != null && me.endpoint != null;
  hubs = filter (peer: peer.endpoint != null) peers;
  others = filter (peer: peer.name != cfg.self) peers;

  # A hub is routed everything; spokes are routed their single /32.
  toNetworkdPeer =
    peer:
    {
      PublicKey = peer.publicKey;
      AllowedIPs =
        if isHub then
          [ "${peer.ip}/32" ]
        else if peer.endpoint != null then
          [ "0.0.0.0/0" "${peer.ip}/32" ]
        else
          [ "${peer.ip}/32" ];
    }
    // optionalAttrs (peer.endpoint != null) { Endpoint = peer.endpoint; }
    // optionalAttrs (peer.persistentKeepalive != null) {
      PersistentKeepalive = peer.persistentKeepalive;
    };

  hubDns =
    if cfg.dns != null then
      cfg.dns
    else if hubs == [ ] then
      null
    else
      (lib.head hubs).ip;
in
{
  options.meta.wireguard = {
    enable = mkEnableOption "enable the wg0 interface";

    self = mkOption {
      type = types.str;
      default = "";
      description = "Key of this host in meta.wireguard.peers.";
    };

    privateKeyFile = mkOption {
      type = types.either types.str types.path;
      default = "/etc/systemd/network/wg0.key";
      description = "Private key of this host.";
    };

    address = mkOption {
      type = types.str;
      default = "10.0.0.1/24";
      description = "Address of this host on the wireguard network.";
    };

    dns = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Per-link DNS handed to systemd-networkd. Defaults to the address of
        the hub peer.
      '';
    };

    peers = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            ip = mkOption {
              type = types.str;
              description = "Address of the peer inside the wireguard network.";
            };
            publicKey = mkOption {
              type = types.str;
              description = "Public key of the peer.";
            };
            endpoint = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "host:port; set on hubs only.";
            };
            persistentKeepalive = mkOption {
              type = types.nullOr types.int;
              default = null;
              description = "PersistentKeepalive in seconds, usually set on the hub entry.";
            };
          };
        }
      );
      default = { };
      description = "All peers of the mesh, including this host.";
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
            PrivateKeyFile = toString cfg.privateKeyFile;
            FirewallMark = 6969;
          };
          wireguardPeers = map toNetworkdPeer hubs;
        };
        networks.wg0 = {
          matchConfig.Name = "wg0";
          networkConfig = {
            Address = cfg.address;
            DNSDefaultRoute = true;
          }
          // optionalAttrs (hubDns != null) {
            DNS = hubDns;
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
              To = "192.168.0.0/16";
              Priority = 5;
            }
            {
              To = "172.16.42.0/24";
              Priority = 5;
            }
          ]
          ++ map (hub: {
            To = "${rmPort hub.endpoint}/32";
            Priority = 5;
          }) hubs;
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
        netdevs."10-wg0" = {
          netdevConfig = {
            Kind = "wireguard";
            Name = "wg0";
            Description = "Wireguard virtual device (tunnel)";
          };
          wireguardConfig = {
            PrivateKeyFile = toString cfg.privateKeyFile;
            ListenPort = 51820;
          };
          wireguardPeers = map toNetworkdPeer others;
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
