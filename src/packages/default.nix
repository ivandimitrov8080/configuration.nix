{ inputs, ... }: {
  perSystem =
    { system, pkgs, ... }: {
      config.packages = {
        nvim = inputs.ide.nvim.${system}.standalone.default {
          plugins.lsp.servers = {
            bashls.enable = true;
            pylsp.enable = true;
            lua-ls.enable = true;
          };
          extraPlugins = with pkgs.vimPlugins; [ vim-just ];
        };
        wpd = pkgs.writeShellApplication {
          name = "wpd";
          runtimeInputs = with pkgs; [ swaybg xdg-user-dirs fd uutils-coreutils-noprefix ];
          runtimeEnv = { WAYLAND_DISPLAY = "wayland-1"; };
          text = ''
            random_pic () {
              bg_dir="$(xdg-user-dir PICTURES)/bg"
              fd . --extension png "$bg_dir" | shuf -n1
            }
            swaybg -i "$(random_pic)" -m fill &
            OLD_PID=$!
            while true; do
                sleep 60
                swaybg -i "$(random_pic)" -m fill &
                NEXT_PID=$!
                sleep 5
                kill -9 $OLD_PID
                OLD_PID=$NEXT_PID
            done
          '';
        };
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
        webshite = inputs.webshite.packages.${system}.default;
        sal = inputs.sal.packages."x86_64-linux".default;
      };
    };
}
