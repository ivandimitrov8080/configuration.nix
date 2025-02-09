{ withSystem, ... }:
{
  flake.overlays.default = _: _: withSystem "x86_64-linux" ({ config, ... }: config.packages);
}
