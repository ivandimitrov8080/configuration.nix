{ pkgs }: {
  programs.firefox = {
    enable = true;
    profiles.ivand = {
      id = 0;
      search.default = "DuckDuckGo";
      bookmarks = [
        {
          name = "home-options";
          url = "https://nix-community.github.io/home-manager/options.xhtml";
        }
      ];
      settings = {
        "general.smoothScroll" = true;
        "signon.rememberSignons" = false;
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "layout.frame_rate" = 120;
      };
    };
    policies = {
      CaptivePortal = false;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxAccounts = true;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      PasswordManagerEnabled = false;

      FirefoxHome = {
        Search = true;
        Pocket = false;
        Snippets = false;
        TopSites = false;
        Highlights = false;
      };

      UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
      };

      Handlers = {
        schemes = {
          mailto = {
            action = "useHelperApp";
            ask = false;
            handlers = [
              {
                name = "RoundCube";
                uriTemplate = "https://mail.idimitrov.dev/?_task=mail&_action=compose&_to=%s";
              }
            ];
          };
        };
      };
    };
  };
  home = {
    file.".mozilla/native-messaging-hosts/gpgmejson.json".text = builtins.toJSON {
      name = "gpgmejson";
      description = "Integration with GnuPG";
      path = "${pkgs.gpgme.dev}/bin/gpgme-json";
      type = "stdio";
      allowed_extensions = [
        "jid1-AQqSMBYb0a8ADg@jetpack"
      ];
    };
  };
}
