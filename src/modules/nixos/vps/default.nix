{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;
  cfg = config.vps;
in
{
  options.vps = {
    enable = mkEnableOption "enable vps config";
  };

  config = mkIf cfg.enable {
    networking = {
      nftables = {
        enable = true;
      };
      firewall.interfaces = {
        wg0 = {
          allowedTCPPorts = [
            22
            53
            993
          ];
        };
      };
    };
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
            PrivateKeyFile = "/etc/systemd/network/wg0.key";
            ListenPort = 51820;
          };
          wireguardPeers = [
            {
              PublicKey = "rZJ7mJl0bmfWeqpUalv69c+TxukpTaxF/SN+RyxklVA=";
              AllowedIPs = [ "10.0.0.2/32" ];
            }
            {
              PublicKey = "RqTsFxFCcgYsytcDr+jfEoOA5UNxa1ZzGlpx6iuTpXY=";
              AllowedIPs = [ "10.0.0.3/32" ];
            }
            {
              PublicKey = "1e0mjluqXdLbzv681HlC9B8BfGN8sIXIw3huLyQqwXI=";
              AllowedIPs = [ "10.0.0.4/32" ];
            }
            {
              PublicKey = "IDe1MPtS46c2iNcE+VrOSUpOVGMXjqFl+XV5Z5U+DDI=";
              AllowedIPs = [ "10.0.0.5/32" ];
            }
          ];
        };
      };
      networks.wg0 = {
        matchConfig.Name = "wg0";
        networkConfig = {
          IPMasquerade = "both";
          Address = "10.0.0.1/24";
        };
      };
    };
  };
}
