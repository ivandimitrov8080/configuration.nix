# Per-host wiring that used to be copy-pasted into every host flake's
# modules.nix: platform, overlay stack, registry pins, stateVersion and the
# default login shell. Hosts only supply data via meta.host.*.
#
# `inputs` comes from the host flake's specialArgs. It is optional so that the
# module stays evaluable in contexts that have no flake inputs (the vps
# integration test imports nixosModules.default directly).
{
  pkgs,
  lib,
  config,
  inputs ? { },
  ...
}:
let
  inherit (lib) mkIf mkMerge mkOption types;
  cfg = config.meta.host;

  # The overlay lives in this flake, so it can be referenced without going
  # through the host's inputs.
  configurationOverlay = import ../../../../overlays;
in
{
  options.meta.host = {
    platform = mkOption {
      type = types.str;
      default = "x86_64-linux";
      description = "nixpkgs.hostPlatform of this host.";
    };

    overlays = mkOption {
      type = types.listOf types.unspecified;
      default = [ ];
      description = ''
        Host specific overlays, applied before the configuration.nix overlay.
        Anything that needs a flake input the host owns (emacs-overlay, the
        host's own package overlay, ...) belongs here, because only the host
        knows its inputs.
      '';
    };

    registry.enable = mkOption {
      type = types.bool;
      default = inputs ? self && inputs ? nixpkgs;
      description = ''
        Pin this host's flake and nixpkgs in nix.registry. Enabled
        automatically when the host passes its flake inputs.
      '';
    };
  };

  config = mkMerge [
    {
      nixpkgs = {
        hostPlatform = cfg.platform;
        overlays = cfg.overlays ++ [ configurationOverlay ];
      };
      system.stateVersion = lib.trivial.release;
      users.defaultUserShell = pkgs.nushell;
    }

    (mkIf cfg.registry.enable {
      nix.registry = {
        self.flake = inputs.self;
        nixpkgs.flake = inputs.nixpkgs;
        p.flake = inputs.nixpkgs;
      };
    })
  ];
}
