{ writeScriptBin, ... }: writeScriptBin "xin" (builtins.readFile ./main.nu)
