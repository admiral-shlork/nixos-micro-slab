{ config, lib, pkgs, modulesPath, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  nixpkgs.config.nvidia.acceptLicense = true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  hardware.enableAllFirmware = true;
  hardware.firmware = [ pkgs.linux-firmware ];
}
