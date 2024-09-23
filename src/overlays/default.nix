{ withSystem, ... }: {
  flake.overlays.default = _: _:
    withSystem "x86_64-linux" (
      { config, ... }: with config.packages; {
        inherit nvim bingwp screenshot cursors wpd webshite sal;
      }
    );
}
