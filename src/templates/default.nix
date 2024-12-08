let
  mkWelcomeText =
    {
      name,
      description,
      path,
      buildTools ? null,
      additionalSetupInfo ? null,
    }:
    {
      inherit path;

      description = name;

      welcomeText = ''
        # ${name}
        ${description}

        ${
          if buildTools != null then
            ''
              Comes bundled with:
              ${builtins.concatStringsSep ", " buildTools}
            ''
          else
            ""
        }
        ${
          if additionalSetupInfo != null then
            ''
              ## Additional Setup
              To set up the project run:
              ```sh
              flutter create .
              ```
            ''
          else
            ""
        }
      '';
    };
in
{
  flake.templates = {
    default = mkWelcomeText {
      path = ./empty;
      name = "Empty Template";
      description = ''
        A default flake with an input
      '';
    };
  };
}
