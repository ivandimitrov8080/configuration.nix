{ pkgs, ... }:
{
  security = {
    sudo = {
      execWheelOnly = true;
      extraRules = [
        {
          groups = [ "wheel" ];
          commands = [
            {
              command = "${pkgs.brightnessctl}/bin/brightnessctl";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
    doas = {
      extraRules = [
        {
          groups = [ "wheel" ];
          noPass = true;
          keepEnv = true;
        }
      ];
    };
    polkit.enable = true;
    rtkit.enable = true;
  };
}
