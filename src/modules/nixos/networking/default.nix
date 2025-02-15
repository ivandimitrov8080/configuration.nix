{ inputs, ... }:
{
  networking = {
    stevenBlackHosts = {
      enable = true;
      blockFakenews = true;
      blockGambling = true;
    };
    extraHosts = ''
      10.0.0.1 mail.idimitrov.dev
      10.0.0.1 idimitrov.dev
    '';
    useNetworkd = true;
  };
}
