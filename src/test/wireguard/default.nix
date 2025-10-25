{ pkgs, configuration, ... }:
let
  hubPub = builtins.readFile ./hub.pub;
  spoke1Pub = builtins.readFile ./spoke1.pub;
  spoke2Pub = builtins.readFile ./spoke2.pub;
  mod = configuration.nixosModules.default;
in
pkgs.testers.runNixOSTest {
  name = "wireguard-integration";
  nodes = {
    hub =
      { pkgs, ... }:
      {
        imports = [ mod ];
        meta.wireguard = {
          enable = true;
          isHub = true;
          address = "10.0.0.1/24";
          privateKeyFile = ./hub.priv;
          peers = [
            {
              PublicKey = spoke1Pub;
              AllowedIPs = [ "10.0.0.2/32" ];
            }
            {
              PublicKey = spoke2Pub;
              AllowedIPs = [ "10.0.0.3/32" ];
            }
          ];
        };
      };
    spoke1 =
      { pkgs, ... }:
      {
        imports = [ mod ];
        meta.wireguard = {
          enable = true;
          isHub = false;
          address = "10.0.0.2/24";
          privateKeyFile = ./spoke1.priv;
          peers = [
            {
              PublicKey = hubPub;
              AllowedIPs = [ "10.0.0.1/32" ];
              Endpoint = "hub:51820";
            }
          ];
        };
      };
    spoke2 =
      { pkgs, ... }:
      {
        imports = [ mod ];
        meta.wireguard = {
          enable = true;
          isHub = false;
          address = "10.0.0.3/24";
          privateKeyFile = ./spoke2.priv;
          peers = [
            {
              PublicKey = hubPub;
              AllowedIPs = [ "10.0.0.1/32" ];
              Endpoint = "hub:51820";
            }
          ];
        };
      };
  };

  testScript = ''
    hub.wait_for_unit("network-online.target")
    spoke1.wait_for_unit("network-online.target")
    spoke2.wait_for_unit("network-online.target")

    spoke1.succeed("ping -c1 10.0.0.1")
    spoke2.succeed("ping -c1 10.0.0.1")
    hub.succeed("ping -c1 10.0.0.2")
    hub.succeed("ping -c1 10.0.0.3")
  '';
}
