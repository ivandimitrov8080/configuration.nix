{
  outputs = _: {
    nixosModules = {
      default = import ./src/nixos;
    };
    homeManagerModules = {
      default = import ./src/homeManager;
    };
  };
}
