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
    ./modules/meta/bingwp
    ./modules/meta/dns
    ./modules/meta/grafana
    ./modules/meta/graphicalBoot
    ./modules/meta/graphics
    ./modules/meta/host
    ./modules/meta/hyprland
    ./modules/meta/minimal
    ./modules/meta/shells
    ./modules/meta/swayland
    ./modules/meta/wireguard
    defs
  ];
}
