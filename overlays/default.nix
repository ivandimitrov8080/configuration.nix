top@{ inputs, withSystem, ... }: {
  flake.overlays.default = final: prev:
    let system = prev.stdenv.hostPlatform.system; in
    withSystem system (
      { config, ... }: {
        nvim = config.packages.nvim;
        bingwp = config.packages.bingwp;
        screenshot = config.packages.screenshot;
        cursors = config.packages.cursors;
        wpd = config.packages.wpd;
        sal = inputs.sal.packages.${system}.default;
      }
    );
}
