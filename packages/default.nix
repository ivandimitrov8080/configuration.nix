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
        let today = (date now | format date '%Y-%m-%d')
        let pic_dir = (xdg-user-dir PICTURES)
        let bg_dir = $pic_dir | path join "bg"
        let today_img_file = $bg_dir | path join ( [ $today, ".png" ] | str join )
        let is_new = ((date now | format date "%H" | into int) >= 10)
        mkdir $bg_dir

        def exists [file: path] {
          return ($file | path exists)
        }

        def is_empty [file: path] {
          return ((exists $file) and ((ls $file | get size | first | into int) == 0))
        }

        def fetch [] {
          http get ("https://bing.com" + ((http get https://www.bing.com/HPImageArchive.aspx?format=js&n=1).images.0.url)) | save $today_img_file
        }

        def cleanup [] {
          if (is_empty $today_img_file) {
            rm -rf $today_img_file
          }
        }

        cleanup

        if $is_new and (not (exists $today_img_file)) {
          fetch
          /run/current-system/sw/bin/ln -sf $today_img_file ( $pic_dir | path join "bg.png" )
        }

        cleanup
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
    };
  };
}
