{ writers, ... }: writers.writeNuBin "xin" (builtins.readFile ./main.nu)
