{
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.0.0.2/24" "fdc9:281f:04d7:9ee9::2/64" ];
      dns = [ "1.1.1.1" "fdc9:281f:04d7:9ee9::1" ];
      privateKeyFile = "/etc/wireguard/privatekey";

      peers = [
        {
          publicKey = "5FiTLnzbgcbgQLlyVyYeESEd+2DtwM1JHCGz/32UcEU=";
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          endpoint = "37.205.13.29:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
