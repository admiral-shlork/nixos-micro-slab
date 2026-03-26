{ config, pkgs, ... }:
let
  # When using 'easyCerts = true;', the IP address must resolve to the master at the time of creation. 
  # In this case, set 'kubeMasterIP = "127.0.0.1";'. Otherwise, you may encounter the following issue: https://github.com/NixOS/nixpkgs/issues/59364.
  kubeMasterIP = "10.0.0.107";
  kubeMasterHostname = "master.micro-slab";
  kubeMasterAPIServerPort = 6443;
in
{
  # resolve master hostname
  networking.extraHosts = "${kubeMasterIP} ${kubeMasterHostname}";

  # packages for administration tasks
  environment.systemPackages = with pkgs; [
    kompose
    kubectl
    kubernetes
  ];

  services.kubernetes = {
    roles = ["master" "node"];
    masterAddress = kubeMasterHostname;
    apiserverAddress = "https://${kubeMasterHostname}:${toString kubeMasterAPIServerPort}";
    easyCerts = true;
    apiserver = {
      securePort = kubeMasterAPIServerPort;
      advertiseAddress = kubeMasterIP;
    };

    # use coredns
    addons.dns.enable = true;

    # needed if you use swap
    kubelet.extraOpts = "--fail-swap-on=false --cgroup-driver=systemd";
  };

  system.activationScripts.kubernetes-key-perms = {
    text = ''
      chmod 640 /var/lib/kubernetes/secrets/cluster-admin-key.pem
    '';
    deps = [];
  };
}