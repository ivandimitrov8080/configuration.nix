{
  inputs.configuration.url = "github:ivandimitrov8080/configuration.nix";
  outputs = inputs: inputs.configuration.inputs.parts.lib.mkFlake { inherit inputs; } { imports = [ ./. ]; };
}

