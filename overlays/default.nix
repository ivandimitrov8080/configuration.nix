top@{ inputs, withSystem, ... }: {
  flake.overlays.default = final: prev:
    let system = "x86_64-linux"; in withSystem system (
      { config, ... }: {
        nvim = config.packages.nvim;
        bingwp = config.packages.bingwp;
        screenshot = config.packages.screenshot;
        cursors = config.packages.cursors;
        wpd = config.packages.wpd;
        webshite = config.packages.webshite;
        sal = inputs.sal.packages.${system}.default;
      }
    );
}
