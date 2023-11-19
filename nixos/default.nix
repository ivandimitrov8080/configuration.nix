{ system, nixpkgs, modules, hosts }: {
  laptop = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      ../hardware-configuration.nix
      ./laptop
      modules.dnscrypt
      # modules.gaming
      # modules.wireguard
      # modules.nvidia
      hosts.nixosModule
    ];
  };
}
