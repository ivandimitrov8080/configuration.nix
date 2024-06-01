{ stateVersion, system, nixpkgs, modules, hosts, catppuccin, ... }: {
  laptop = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      { system.stateVersion = stateVersion; }
      ../hardware-configuration.nix
      ./laptop
      modules.nixos.wireguard
      hosts.nixosModule
      catppuccin.nixosModules.catppuccin
    ];
  };
}
