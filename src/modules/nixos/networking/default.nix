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
        "ai.idimitrov.dev"
        "git.idimitrov.dev"
        "idimitrov.dev"
        "mail.idimitrov.dev"
      ];
      "10.0.0.4" = [
        "stara.idimitrov.dev"
      ];
    };
    useNetworkd = true;
  };
}
