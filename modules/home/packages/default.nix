{ pkgs, ... }: {
  dev = import ./dev { inherit pkgs; };
  essential = import ./essential { inherit pkgs; };
}
