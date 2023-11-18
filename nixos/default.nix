{ system, nixpkgs, modules, hosts }: {
  laptop = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      ../hardware-configuration.nix
      ./laptop
      modules.dnscrypt
      hosts.nixosModule
    ];
  };
}
