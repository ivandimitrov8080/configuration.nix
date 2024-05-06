{ system, nixpkgs, modules, hosts, catppuccin, ... }: {
  laptop = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = with modules.nixos; [
      ../hardware-configuration.nix
      ./laptop
      # dnscrypt
      # gaming
      wireguard
      # nvidia
      hosts.nixosModule
      catppuccin.nixosModules.catppuccin
    ];
  };
}
