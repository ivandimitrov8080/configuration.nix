# Per-host data that the shared modules need: stateVersion and the public
# address. The platform, overlay stack and registry pins are set directly by
# each host flake, because only the host knows its inputs.
{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.meta.host;
in
{
  options.meta.host = {
    stateVersion = mkOption {
      type = types.str;
      default = "26.05";
      description = ''
        NixOS stateVersion of this host. This is deliberately data supplied by
        each host and must not follow the nixpkgs release.
      '';
    };

    publicAddress = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Public IP address of this host, when it has one.";
    };
  };

  config = {
    system.stateVersion = cfg.stateVersion;
    users.defaultUserShell = pkgs.nushell;
  };
}
