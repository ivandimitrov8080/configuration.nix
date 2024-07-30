top@{ inputs, ... }: {
  perSystem = perSystem@{ system, pkgs, ... }: {
    config.packages = {
      nvim = inputs.ide.nvim.${system}.standalone.default {
        plugins.lsp.servers = {
          bashls.enable = true;
          pylsp.enable = true;
          lua-ls.enable = true;
        };
      };
      bingwp = pkgs.writers.writeNuBin "bingwp" ''
        http get "https://pic.idimitrov.dev/latest.png" | save -f ([(xdg-user-dir PICTURES), "bg.png"] | str join "/")
      '';
      screenshot = pkgs.writeShellApplication {
        name = "screenshot";
        runtimeInputs = with pkgs; [ wl-clipboard xdg-utils ];
        text = ''
          ss_dir="$(xdg-user-dir PICTURES)/ss"
          pic_dir="$ss_dir/$(date "+%Y-%m-%d_%H-%M-%S").png"

          mkdir -p "$ss_dir"

          copy_image () {
            wl-copy < "$pic_dir"
          }

          main () {
            grim "$pic_dir"
            copy_image
          }

          main
        '';
      };
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
