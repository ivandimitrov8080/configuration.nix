{
  lib,
  config,
  pkgs,
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
  cfg = config.custom.wireguard;
in
{
  options.custom.wireguard = {
    enable = mkEnableOption "custom wireguard config to be used as a VPN client";
    killswitch = mkEnableOption "wireguard killswitch to prevent leaks";
    ips = mkOption {
      description = "The IP addr of the interface";
      type = types.listOf types.str;
      default = null;
    };
    privateKeyFile = mkOption {
      description = "Path to wg private key";
      type = types.str;
      default = null;
    };
    peers = mkOption {
      description = "wg peers name, public key, allowed ips";
      type = types.list;
      default = [];
    };
  };
  config = mkMerge [
    (mkIf cfg.killswitch {
      networking = {
        nftables = {
          enable = true;
          ruleset = ''
            table inet killswitch {
              chain output {
                type filter hook output priority 0; policy drop;
                oifname "lo" accept
                oifname "wg0" accept
                meta mark 0x1b39 accept
                ct state established,related accept
              }
            }
          '';
        };
      };
    })
    (mkIf cfg.enable {
      networking = {
        wireguard = {
          enable = true;
          useNetworkd = true;
          interfaces.wg0 = {
            table = "1000";
            fwMark = "0x1b39";
            ips = cfg.ips;
            privateKeyFile = cfg.privateKeyFile;
            peers = cfg.peers;
          };
        };
      };
      systemd.network.networks."40-wg0".routingPolicyRules = [
        {
          FirewallMark = 6969;
          InvertRule = true;
          Table = 1000;
          Priority = 10;
        }
        {
          SuppressPrefixLength = 0;
          Table = "main";
          Priority = 20;
        }
      ];
    })
  ];
}
