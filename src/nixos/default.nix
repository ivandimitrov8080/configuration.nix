{
  pkgs,
  lib,
  options,
  config,
  ...
}:
let
  inherit (import ../lib { inherit lib; }) mkDefaultAttrs;
  defs = mkDefaultAttrs (
    import ./defaults {
      inherit
        pkgs
        config
        lib
        options
        ;
    }
  );
in
{
  imports = [
    ./modules/custom/bingwp
    ./modules/custom/dns
    ./modules/custom/graphicalBoot
    ./modules/custom/graphics
    ./modules/custom/host
    ./modules/custom/hyprland
    ./modules/custom/minimal
    ./modules/custom/shells
    ./modules/custom/swayland
    ./modules/custom/wireguard
    defs
  ];
}
