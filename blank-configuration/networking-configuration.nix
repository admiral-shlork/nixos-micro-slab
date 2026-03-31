{ config, pkgs, lib, modulesPath, ... }:

{
  networking = {
    hostName = "micro-slab";
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 80 88 8080 8888 9090 6443 10257 10259 9000 ];
    firewall.allowedUDPPorts = [ ];
  };
}
