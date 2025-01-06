{ lib, ... }:
with lib;
{
  services.gitea = {
    appName = mkDefault "src";
    database = {
      type = mkDefault "postgres";
    };
    settings = mkDefault {
      server = {
        DOMAIN = "src.idimitrov.dev";
        ROOT_URL = "https://src.idimitrov.dev/";
        HTTP_PORT = 3001;
      };
      repository = {
        DEFAULT_BRANCH = "master";
      };
      service = {
        DISABLE_REGISTRATION = true;
      };
    };
  };

}
