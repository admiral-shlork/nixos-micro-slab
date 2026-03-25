{ config, pkgs, ... }:
{
  services.xserver.enable = false;
  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    btop
    docker
    git
    home-manager
    nh
    python3
    python311Packages.pip
    screen
    vim
    wget
  ];
}
