_: {
  flake = {
    hardwareConfigurations = {
      nova =
        { ... }:
        {
          boot = {
            initrd.luks.devices."nixos".device = "/dev/disk/by-uuid/712dd8ba-d5b4-438a-9a77-663b8c935cfe";
            kernelModules = [ "kvm-intel" ];
          };
          fileSystems = {
            "/" = {
              device = "/dev/disk/by-uuid/47536cbe-7265-493b-a2e3-bbd376a6f9af";
              fsType = "btrfs";
            };
            "/boot" = {
              device = "/dev/disk/by-uuid/4C3C-993A";
              fsType = "vfat";
            };
          };
          nixpkgs.hostPlatform = "x86_64-linux";
        };
    };
  };
}
