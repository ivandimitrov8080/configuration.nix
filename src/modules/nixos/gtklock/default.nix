{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    mkPackageOption
    types
    optionalString
    getName
    readFile
    ;
  cfg = config.programs.gtklock;
  style = # css
    ''
      @import "${pkgs.themes-gtk}/mocha.css";
      window {
         background-image: url("/home/ivand/.local/state/wpaperd/wallpapers/eDP-1");
         background-size: cover;
         background-repeat: no-repeat;
         background-position: center;
         background-color: black;
      }
      #window-box {
        padding: 69px;
        border-radius: 7px;
        background-color: alpha(@base, 0.85);
      }
      #clock-label, #date-label, #input-label {
        color: @text;
      }
      #input-field {
        color: @crust;
        border-radius: 7px;
        border-color: @sky;
      }
      #unlock-button {
        background-color: alpha(@sky, 0.85);
        background-image: none;
        color: @base;
      }
    '';
in
{
  options.programs.gtklock = {
    enable = mkEnableOption "enable vps config";
    package = mkPackageOption pkgs "gtklock" { };
    modules = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        gtklock-playerctl-module
      ];
      description = ''
        The plugins to add to the config file.
      '';
    };
    style = mkOption {
      type = with types; (nullOr (either path lines));
      default = style;
      description = ''
        CSS style of gtklock.

        See <https://github.com/jovanlanik/gtklock/wiki#styling>
        for the documentation.

        If the value is set to a path literal, then the path will be used.
      '';
      example = # css
        ''
          window {
             background-image: url("background.png");
             background-size: cover;
             background-repeat: no-repeat;
             background-position: center;
             background-color: black;
          }
        '';
    };
    configExtra = mkOption {
      type = with types; (nullOr (either path lines));
      default = null;
      description = ''
        config.ini for gtklock

        See <https://github.com/jovanlanik/gtklock/wiki#config>
        for the documentation.

        If the value is set to a path literal, then the path will be used.
      '';
      example = # ini
        ''
          [main]
          gtk-theme=Adwaita-dark
        '';
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
      etc = {
        "xdg/gtklock/config.ini" =
          mkIf (cfg.style != null || cfg.configExtra != null || cfg.modules != null)
            {
              text = ''
                [main]
                ${optionalString (cfg.style != null) "style=${pkgs.writeText "styles.css" cfg.style}"}
                ${optionalString (cfg.modules != null)
                  "modules=${
                    builtins.concatStringsSep ";" (
                      builtins.map (
                        x: "${x}/lib/gtklock/${builtins.replaceStrings [ "gtklock-" ] [ "" ] (getName x)}.so"
                      ) cfg.modules
                    )
                  }"
                }
                ${optionalString (cfg.configExtra != null) (
                  if builtins.isPath cfg.configExtra || lib.isStorePath cfg.configExtra then
                    readFile cfg.configExtra
                  else
                    cfg.configExtra
                )}
              '';
            };
      };
    };

    security.pam.services.gtklock = { };
  };
}
