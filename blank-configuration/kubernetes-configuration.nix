{ config, pkgs, ... }:
let
  # When using 'easyCerts = true;', the IP address must resolve to the master at the time of creation. 
  # In this case, set 'kubeMasterIP = "127.0.0.1";'. Otherwise, you may encounter the following issue: https://github.com/NixOS/nixpkgs/issues/59364.
  kubeMasterIP = "10.0.0.107";
  kubeMasterHostname = "master.micro-slab";
  kubeMasterAPIServerPort = 6443;
  kubeMasterFullAddress = "https://${kubeMasterHostname}:${toString kubeMasterAPIServerPort}";
in
{
  networking.extraHosts = "${kubeMasterIP} ${kubeMasterHostname}";

  environment.systemPackages = with pkgs; [
    kompose
    kubectl
    kubernetes
  ];

  services.kubernetes = {
    roles = ["master" "node"];
    masterAddress = kubeMasterHostname;
    apiserverAddress = kubeMasterFullAddress;
    easyCerts = true;
    apiserver = {
      securePort = kubeMasterAPIServerPort;
      advertiseAddress = kubeMasterIP;
    };
    addons.dns.enable = true;
    kubelet.extraOpts = "--fail-swap-on=false --cgroup-driver=systemd";
  };

  systemd.tmpfiles.rules = [
    "m /var/lib/kubernetes/secrets/cluster-admin-key.pem 0640 root root -"
  ];

  # Watch for cert renewal and re-apply group permissions immediately
  systemd.paths.fix-cluster-admin-key-perms = {
    wantedBy = [ "multi-user.target" ];
    pathConfig = {
      PathChanged = "/var/lib/kubernetes/secrets/cluster-admin-key.pem";
      Unit = "fix-cluster-admin-key-perms.service";
    };
  };

  systemd.services.fix-cluster-admin-key-perms = {
    description = "Fix cluster-admin-key.pem group permissions after certmgr renewal";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/chmod 640 /var/lib/kubernetes/secrets/cluster-admin-key.pem";
    };
  };

}