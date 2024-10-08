toplevel@{ ... }: {
  perSystem = { pkgs, ... }: {
    config.packages = {
      mailserver =
        let
          mods = toplevel.config.flake.nixosModules;
        in
        pkgs.testers.runNixOSTest {
          name = "mailserver-test";
          nodes.server = { ... }: {
            imports = with mods; [ base shell security mailserver nginx wireguard-output anonymous-dns firewall rest ];
          };
          nodes.client = { pkgs, ... }: {
            environment.systemPackages = with pkgs; [
              curl
            ];
          };
          testScript = ''
            server.wait_for_unit("default.target")
            server.succeed("su -- ivand -c 'which zsh'")
            server.succeed("su -- ivand -c 'which zsh'")
            client.wait_for_unit("default.target")
            client.succeed("curl http://server/ | grep '301 Moved Permanently'")
          '';
        };
    };
  };
}
