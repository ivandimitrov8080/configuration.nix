{
  systemd.network = {
    netdevs = {
      "10-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
          Description = "Wireguard virtual network device (tunnel)";
        };
        wireguardConfig = {
          PrivateKeyFile = "/etc/systemd/network/wg0.key";
          FirewallMark = 6969;
        };
        wireguardPeers = [
          {
            PublicKey = "iRSHYRPRELX8lJ2eHdrEAwy5ZW8f5b5fOiIGhHQwKFg=";
            AllowedIPs = [
              "0.0.0.0/0"
            ];
            Endpoint = "37.205.13.29:51820";
          }
        ];
      };
    };
    networks.wg0 = {
      matchConfig.Name = "wg0";
      networkConfig = {
        Address = "10.0.0.2/24";
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
}
