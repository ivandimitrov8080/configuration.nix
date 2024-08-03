{ ... }:
{
  services.gitea = {
    enable = true;
    appName = "src";
    database = {
      type = "postgres";
    };
    settings = {
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
