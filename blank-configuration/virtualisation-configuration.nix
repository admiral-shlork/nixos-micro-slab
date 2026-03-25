{ config, pkgs, lib, modulesPath, ... }:

{
  virtualisation = {
    docker = {
      enable = true;
    };
  };
}