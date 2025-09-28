# NixOS configurations

This repository aims to configure everything I use for all my machines.

### Goals

- Provide me with something that I personally can use.
- Make it modular so that it can be reused by other people or me on other people's machines.

### How to use

In `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    configuration.url = "github:ivandimitrov8080/configuration.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      configuration,
    }:
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        modules =
          let
            system = "x86_64-linux";
          in
          [
            {
              imports = [ configuration.nixosModules.default ];
              nixpkgs.hostPlatform = system;
              meta.shells.enable = true;
              users.users.test = {
                isNormalUser = true;
                createHome = true;
                password = "test";
                extraGroups = [ "wheel" ];
              };
            }
          ];
      };
    };
}
```

Run the following for more info:
```bash
nix flake show github:ivandimitrov8080/configuration.nix
```

