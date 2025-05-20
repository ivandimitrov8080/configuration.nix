_: {
  flake = {
    hardwareConfigurations = {
      nova =
        { lib, modulesPath, ... }:
        {
          imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
          boot = {
            initrd = {
              availableKernelModules = [
                "xhci_pci"
                "thunderbolt"
                "nvme"
                "usb_storage"
                "sd_mod"
                "sdhci_pci"
              ];
              kernelModules = [ ];
              luks.devices."nixos".device = "/dev/disk/by-uuid/712dd8ba-d5b4-438a-9a77-663b8c935cfe";
            };
            kernelModules = [ "kvm-intel" ];
            extraModulePackages = [ ];
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
          swapDevices = [ ];
          networking.useNetworkd = lib.mkDefault true;
          nixpkgs.hostPlatform = lib.mkForce "x86_64-linux";
          hardware.cpu.intel.updateMicrocode = lib.mkForce false;
        };
      stara =
        {
          lib,
          modulesPath,
          config,
          ...
        }:
        {
          imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
          ];

          boot.initrd.availableKernelModules = [
            "xhci_pci"
            "ahci"
            "usb_storage"
            "sd_mod"
          ];
          boot.initrd.kernelModules = [ ];
          boot.kernelModules = [ "kvm-intel" ];
          boot.extraModulePackages = [ ];
          boot.initrd.luks.devices."data".device = "/dev/disk/by-uuid/1d86ba3e-a763-47dd-ab1b-961c0e44a921";

          fileSystems."/" = {
            device = "/dev/disk/by-uuid/23cab329-d467-45d1-acc4-8bf43958c1ab";
            fsType = "btrfs";
          };

          fileSystems."/boot" = {
            device = "/dev/disk/by-uuid/ACB8-8C22";
            fsType = "vfat";
            options = [
              "fmask=0022"
              "dmask=0022"
            ];
          };

          fileSystems."/data" = {
            device = "/dev/disk/by-uuid/03899bce-b54f-4e02-9bf6-e3800df82304";
            fsType = "btrfs";
          };

          networking.useNetworkd = lib.mkDefault true;

          swapDevices = [ ];

          nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
          hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        };
    };
  };
}
