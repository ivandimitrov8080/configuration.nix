{ withSystem, ... }: {
  flake.overlays.default = _: prev:
    withSystem "x86_64-linux" (
      { config, ... }: with config.packages; {
        inherit nvim bingwp screenshot rofi-themes mutt-themes webshite webshiteApi flake wpaperd;
      }
    );
}
