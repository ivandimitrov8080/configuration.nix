{ pkgs, ... }: {
  imports = [
    ./neovim
    ./doom-emacs
    ./git.nix
    ./tmux.nix
    ./kitty.nix
    ./swaylock.nix
    ./zsh.nix
    ./obs.nix
  ];

  programs = {
    thunderbird = {
      enable = true;
      profiles = {
        ivan = {
          isDefault = true;
        };
      };
    };
    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
    };
  };
}
