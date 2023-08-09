{ pkgs, ... }: {
  home.packages = with pkgs; [
    bemenu
    brave
    direnv
    gopass
    gopass-jsonapi
    pavucontrol
    nixfmt
    sqlite
    ripgrep
  ];
}
