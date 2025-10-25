{ pkgs, ... }:
pkgs.testers.runNixOSTest {
  name = "test";
  nodes = {
    machine =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.hello ];
      };
  };
  testScript =
    #py
    ''
      machine.wait_for_unit("multi-user.target");
      machine.succeed("hello");
    '';
}
