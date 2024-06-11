{ ... }: {
  imports = [ ./nixos ];
  systems = [ "x86_64-linux" ];
  perSystem = { inputs, system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs { inherit system; };
  };
}
