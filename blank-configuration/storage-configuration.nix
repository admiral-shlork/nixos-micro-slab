{ config, pkgs, modulesPath, ... }:

{
  boot = {
    initrd.availableKernelModules = [ "ahci" "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ "dm-snapshot" ];
    kernelParams = [ "fbcon=rotate:3"];
    kernelModules = [ "kvm-intel" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  swapDevices = [{
      device = "/swapfile";
      size = 16 * 1024;
    }];

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  
  fileSystems."/" =
    { device = "/dev/disk/by-label/root";
      fsType = "ext4";
    };
}
