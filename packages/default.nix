top@{ inputs, ... }: {
  perSystem = perSystem@{ system, pkgs, ... }: {
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
      bingwp = pkgs.writers.writeNuBin "bingwp" ''
        http get "https://pic.idimitrov.dev/latest.png" | save -f ([(xdg-user-dir PICTURES), "bg.png"] | str join "/")
      '';
      screenshot = pkgs.writers.writeNuBin "screenshot" ''
        let tmp_img = "/tmp/screen.png" | path join
        let ss_dir = ((xdg-user-dir PICTURES | str trim) | path join "ss")
        let pic_dir = ($ss_dir | path join ((date now | format date) | str join ".png"))

        mkdir $ss_dir

        def copy_image [] {
          open $pic_dir | wl-copy
        }

        def prepare_screen [] {
          let grim_id = pueue add -i -p grim $tmp_img
          let imv_id = pueue add -a $grim_id -p imv -f $tmp_img
          grim -g $"(slurp -b '#FFFFFF00' -c '#FF0000FF')" $pic_dir
          pueue kill $imv_id $grim_id
          pueue wait
          pueue remove $imv_id $grim_id
        }

        def "main area" [] {
          prepare_screen
          copy_image
        }

        def main [] {
          grim $pic_dir
          copy_image
        }
      '';
      cursors = pkgs.catppuccin-cursors.overrideAttrs (prev: rec {
        version = "0.3.1";
        nativeBuildInputs = prev.nativeBuildInputs ++ [ pkgs.xcur2png ];
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "cursors";
          rev = "v${version}";
          hash = "sha256-CuzD6O/RImFKLWzJoiUv7nlIdoXNvwwl+k5mTeVIY10=";
        };
      });
    };
  };
}
