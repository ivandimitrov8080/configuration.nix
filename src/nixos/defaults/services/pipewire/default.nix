{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  services.pipewire.alsa.enable = mkDefault true;
  services.pipewire.pulse.enable = mkDefault true;
  services.pipewire.jack.enable = mkDefault true;
}
