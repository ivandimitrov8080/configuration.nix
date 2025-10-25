{ pkgs, configuration, ... }:
let
  hubPub = builtins.readFile ./hub.pub;
  spoke1Pub = builtins.readFile ./spoke1.pub;
  spoke2Pub = builtins.readFile ./spoke2.pub;
  mod = configuration.nixosModules.default;
  peers = [
    {
      PublicKey = hubPub;
      AllowedIPs = [ "10.0.0.1/32" ];
      Endpoint = "hub:51820";
    }
    {
      PublicKey = spoke1Pub;
      AllowedIPs = [ "10.0.0.2/32" ];
    }
    {
      PublicKey = spoke2Pub;
      AllowedIPs = [ "10.0.0.3/32" ];
    }
  ];
in
pkgs.testers.runNixOSTest {
  name = "wireguard-integration";
  nodes = {
    hub =
      { pkgs, ... }:
      {
        imports = [ mod ];
        networking.firewall.allowedUDPPorts = [ 51820 ];
        meta.wireguard = {
          enable = true;
          address = "10.0.0.1/24";
          privateKeyFile = ./hub.priv;
          peers = peers;
        };
      };
    spoke1 =
      { pkgs, ... }:
      {
        imports = [ mod ];
        meta.wireguard = {
          enable = true;
          address = "10.0.0.2/24";
          privateKeyFile = ./spoke1.priv;
          peers = peers;
        };
      };
    spoke2 =
      { pkgs, ... }:
      {
        imports = [ mod ];
        meta.wireguard = {
          enable = true;
          address = "10.0.0.3/24";
          privateKeyFile = ./spoke2.priv;
          peers = peers;
        };
      };
  };

  testScript = ''
    start_all()

    hub.wait_for_unit("default.target")
    spoke1.succeed("ping -c1 10.0.0.1")
    spoke2.succeed("ping -c1 10.0.0.1")
    hub.succeed("ping -c1 10.0.0.2")
    hub.succeed("ping -c1 10.0.0.3")
  '';
}
