{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkMerge mkEnableOption;
  cfg = config.cryptocurrency;
in
{
  options.cryptocurrency = {
    moneroMiner.enable = mkEnableOption "enable monero miner config";
  };
  config = mkMerge [
    (mkIf cfg.moneroMiner.enable {
      services = {
        xmrig = {
          enable = true;
          settings = {
            autosave = true;
            cpu = true;
            opencl = false;
            cuda = false;
            pools = [
              {
                url = "pool.supportxmr.com:443";
                user = "48e9t9xvq4M4HBWomz6whiY624YRCPwgJ7LPXngcc8pUHk6hCuR3k6ENpLGDAhPEHWaju8Z4btxkbENpcwaqWcBvLxyh5cn";
                keepalive = true;
                tls = true;
              }
            ];
          };
        };
      };
    })
  ];
}
