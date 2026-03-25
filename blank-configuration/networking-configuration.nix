{ config, pkgs, lib, modulesPath, ... }:

{
  networking = {
    hostName = "micro-slab";
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 80 8080 6443 ];
    firewall.allowedUDPPorts = [ ];
  };
}
