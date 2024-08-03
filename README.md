# NixOS configurations

This repository aims to configure everything I use for all my machines.

### Goals

- Provide me with something that I personally can use.
- Make it modular so that it can be reused by other people or me on other people's machines (my company's workstation).

### How to use

[Check the home-manager modules](./home/modules/default.nix)
[Check the NixOS modules](./nixos/modules/default.nix)

These are exposed in the following way
`<this-flake>.homeManagerModules.<module>`
`<this-flake>.nixosModules.<module>`

Run the following for more info:
```bash
nix flake show github:ivandimitrov8080/configuration.nix
```

