{ inputs, ... }:
{
  networking = {
    stevenBlackHosts = {
      enable = true;
      blockFakenews = true;
      blockGambling = true;
    };
    hosts = {
      "10.0.0.1" = [
        "mail.idimitrov.dev"
        "idimitrov.dev"
        "ai.idimitrov.dev"
      ];
    };
    useNetworkd = true;
  };
}
