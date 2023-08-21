{ pkgs, ... }: {
  programs = {
    lf = {
      enable = true;
      keybindings = {
        D = "delete";
	R = "rename";
      };
    };
  };
}
