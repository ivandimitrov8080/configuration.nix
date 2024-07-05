{
  programs.bottom = {
    enable = true;
    settings = {
      flags = {
        rate = "250ms";
      };
      row = [
        {
          ratio = 40;
          child = [
            { type = "cpu"; }
            { type = "mem"; }
            { type = "net"; }
          ];
        }
        {
          ratio = 35;
          child = [
            { type = "temp"; }
            { type = "disk"; }
          ];
        }
        {
          ratio = 40;
          child = [
            { type = "proc"; default = true; }
          ];
        }
      ];
    };
  };
}
