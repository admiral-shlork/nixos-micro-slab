{ config, lib, pkgs, ... }:
{
  services = {
    openssh.enable = true;
    xserver = {
      enable = false;
      xkb = {
        layout = "pl";
        variant = "";
      };
    };
    prometheus.exporters.node = {
      enable = true;
      port = 9000;
      enabledCollectors = [
        "cpu"
        "cpufreq"
        "diskstats"
        "ethtool"   
        "filesystem"
        "hwmon"
        "loadavg"
        "meminfo"
        "nvme"
        "os"
        "softirqs"
        "systemd"
        "vmstat"
      ];
      extraFlags = [ "--collector.ntp.protocol-version=4" "--no-collector.mdadm" ];
    };
  };

  environment.systemPackages = with pkgs; [
    btop
    docker
    git
    home-manager
    nh
    python3
    screen
    vim
    wget
  ];

  systemd.services.prometheus-node-exporter.serviceConfig = {
    RestrictNamespaces = lib.mkForce false;
    ProtectHome = lib.mkForce false;
  };
}
