{ inputs, config, ... }: {
  flake.nixosConfigurations = {
    nixos = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        ./laptop-hardware.nix
        inputs.hosts.nixosModule
        inputs.catppuccin.nixosModules.catppuccin
      ] ++ (with config.flake.nixosModules; [ wireguard catppuccin boot security xdg networking users services programs env rest ]);
    };
  };
}
