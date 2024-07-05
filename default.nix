top@{ inputs, ... }: {
  imports = [ ./nixos ./home ];
  systems = [ "x86_64-linux" ];
  flake.stateVersion = "24.05";
  perSystem = perSystem@{ config, system, pkgs, ... }: {
    config.packages = {
      nvim = inputs.ide.nvim.${system}.standalone.default {
        autoCmd = [
          {
            callback.__raw = /*lua*/ '' 
              function() require("otter").activate() end 
            '';
            event = [ "BufEnter" "BufWinEnter" "BufWritePost" ];
            pattern = [ "*.nix" ];
          }
        ];
        plugins.lsp.servers = {
          bashls.enable = true;
          pylsp.enable = true;
          lua-ls.enable = true;
        };
        extraPlugins = with pkgs.vimPlugins; [ otter-nvim ];
      };
      scripts = (pkgs.buildEnv { name = "scripts"; paths = [ ./. ]; });
    };
    config._module.args = {
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            nvim = config.packages.nvim;
            scripts = config.packages.scripts;
          })
          inputs.sal.overlays.default
        ];
      };
    };
  };
}
