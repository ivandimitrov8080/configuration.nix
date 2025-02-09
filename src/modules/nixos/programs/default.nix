{ pkgs, ... }:
{
  programs = {
    git = {
      enable = true;
      config = {
        safe.directory = "*";
      };
    };
    gtklock = {
      enable = true;
      modules = with pkgs; [
        gtklock-playerctl-module
      ];
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
    };
    zsh.enable = true;
    nix-ld.enable = true;
  };
}
