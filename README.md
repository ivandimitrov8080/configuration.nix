# My personal nixos config.

### Usage

To build the base system for my craptop:

```bash
sudo nixos-rebuild switch --flake github:ivandimitrov8080/configuration.nix#laptop
```

To build ivand home:

```bash
home-manager switch --flake github:ivandimitrov8080/configuration.nix#ivand
```

To reuse modules:

in your flake.nix:
```nix
inputs.ivan-mods = {
  url = "github:ivandimitrov8080/configuration.nix";
  inputs.nixpkgs.follows = "nixpkgs";
};
outputs = {self, nixpkgs, ivan-mods, ...}:{
...
    homeConfigurations = {
        my-user = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = with ivan-mods.modules.home; [
            programs.nvim
            programs.zsh
          ];
        };
      };
...
};
```

