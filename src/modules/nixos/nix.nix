{ inputs, lib, ... }:
{
  nix = with lib; {
    extraOptions = mkDefault ''experimental-features = nix-command flakes'';
    registry = {
      self.flake = mkDefault inputs.self;
      nixpkgs.flake = mkDefault inputs.nixpkgs;
      p.flake = mkDefault inputs.nixpkgs;
    };
  };
}
