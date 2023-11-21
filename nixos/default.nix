{ system, nixpkgs, modules, hosts }: {
  laptop = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = with modules.nixos;[
      ../hardware-configuration.nix
      ./laptop
      dnscrypt
      # gaming
      # wireguard
      # nvidia
      hosts.nixosModule
    ];
  };
}
