{ config, pkgs, lib, modulesPath, ... }:

{
  networking = {
    hostName = "micro-slab";
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 80 88 8080 9090 6443 10257 10259 ];
    firewall.allowedUDPPorts = [ ];
  };
}
