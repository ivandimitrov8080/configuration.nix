{ pkgs, ... }: {

  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "venet0";
    internalInterfaces = [ "wg0" ];
  };

  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.0.0.1/24" "fdc9:281f:04d7:9ee9::1/64" ];
      listenPort = 51820;
      privateKeyFile = "/etc/wireguard/privatekey";
      postUp = ''
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.1/24 -o venet0 -j MASQUERADE
        ${pkgs.iptables}/bin/ip6tables -A FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o venet0 -j MASQUERADE
      '';
      preDown = ''
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.1/24 -o venet0 -j MASQUERADE
        ${pkgs.iptables}/bin/ip6tables -D FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o venet0 -j MASQUERADE
      '';
      peers = [
        {
          publicKey = "28yXYLk4U0r6MdWFEZzk6apI8uhg962wMprF47wUJyI=";
          allowedIPs = [ "10.0.0.2/32" "fdc9:281f:04d7:9ee9::2/128" ];
        }
        {
          publicKey = "RqTsFxFCcgYsytcDr+jfEoOA5UNxa1ZzGlpx6iuTpXY=";
          allowedIPs = [ "10.0.0.3/32" ];
        }
        {
          publicKey = "kI93V0dVKSqX8hxMJHK5C0c1hEDPQTgPQDU8TKocVgo=";
          allowedIPs = [ "10.0.0.4/32" ];
        }
      ];
    };
  };
}
