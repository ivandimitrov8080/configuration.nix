{ inputs, lib, ... }:
{
  imports = [ inputs.hosts.nixosModule ];
  networking = with lib; {
    dhcpcd.wait = mkDefault "background";
    stevenBlackHosts = {
      enable = mkDefault true;
      blockFakenews = mkDefault true;
      blockGambling = mkDefault true;
    };
  };
}
