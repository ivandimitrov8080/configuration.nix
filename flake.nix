# Host-agnostic configuration shared by every host flake: NixOS/Home Manager
# defaults, input-free meta modules, and a final:prev: package overlay.
{
  outputs = _: {
    nixosModules.default = import ./src/nixos;
    homeManagerModules.default = import ./src/homeManager;
    overlays.default = import ./src/overlays;
  };
}
