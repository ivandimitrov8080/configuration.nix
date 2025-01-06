{ inputs, lib, ... }:
with lib;
let
  cfg = config.wgvpn;
in
{
  imports = [ inputs.hosts.nixosModule ];

  options.wgvpn = {
    enable = mkEnableOption "wgvpn";
  };
  config = mkMerge [
    ({
      networking = {
        dhcpcd.wait = mkDefault "background";
        stevenBlackHosts = {
          enable = mkDefault true;
          blockFakenews = mkDefault true;
        };
      };
    })
    (mkIf cfg.wgvpn.enable {
      networking = {
        nat = {
          enable = true;
          enableIPv6 = true;
          externalInterface = "venet0";
          internalInterfaces = [ "wg0" ];
        };
        wg-quick.interfaces = {
          wg0 =
            let
              iptables = "${pkgs.iptables}/bin/iptables";
              ip6tables = "${pkgs.iptables}/bin/ip6tables";
            in
            {
              address = [ "192.168.69.1/32" ];
              listenPort = 51820;
              privateKeyFile = "/etc/wireguard/privatekey";
              postUp = ''
                ${iptables} -A FORWARD -i wg0 -j ACCEPT
                ${iptables} -t nat -A POSTROUTING -s 192.168.69.1/24 -o venet0 -j MASQUERADE
                ${ip6tables} -A FORWARD -i wg0 -j ACCEPT
                ${ip6tables} -t nat -A POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o venet0 -j MASQUERADE
              '';
              preDown = ''
                ${iptables} -D FORWARD -i wg0 -j ACCEPT
                ${iptables} -t nat -D POSTROUTING -s 192.168.69.1/24 -o venet0 -j MASQUERADE
                ${ip6tables} -D FORWARD -i wg0 -j ACCEPT
                ${ip6tables} -t nat -D POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o venet0 -j MASQUERADE
              '';
              peers = [
                {
                  publicKey = "kI93V0dVKSqX8hxMJHK5C0c1hEDPQTgPQDU8TKocVgo=";
                  allowedIPs = [ "192.168.69.2/32" ];
                }
                {
                  publicKey = "RqTsFxFCcgYsytcDr+jfEoOA5UNxa1ZzGlpx6iuTpXY=";
                  allowedIPs = [ "192.168.69.3/32" ];
                }
                {
                  publicKey = "1e0mjluqXdLbzv681HlC9B8BfGN8sIXIw3huLyQqwXI=";
                  allowedIPs = [ "192.168.69.4/32" ];
                }
                {
                  publicKey = "IDe1MPtS46c2iNcE+VrOSUpOVGMXjqFl+XV5Z5U+DDI=";
                  allowedIPs = [ "192.168.69.5/32" ];
                }
              ];
            };
        };
      };
    })
  ];
}
