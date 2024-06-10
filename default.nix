{ ... }: {
  imports = [ ./nixos ];
  systems = [ "x86_64-linux" ];
  perSystem = { system, ... }: { };
}
