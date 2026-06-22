{ config, lib, modulesPath, pkgs, ... }:

{
  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableAllFirmware = true;
    firmware = [ pkgs.linux-firmware ];
  };
}
