{
  inputs = {
    configuration.url = "github:ivandimitrov8080/configuration.nix";
    nixpkgs.follows = "configuration/nixpkgs";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
  };
  outputs =
    inputs:
    inputs.configuration.inputs.parts.lib.mkFlake { inherit inputs; } { imports = [ ./parts ]; };
}
