{ config, pool, ... }:

{
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  boot.zfs.extraPools = [ pool.name ];

  services.zfs = {
    trim.enable = true;
    autoScrub.enable = true;
  };

  systemd.mounts = [{
    what = "/dev/zvol/zdata/longhorn-data";
    type = "ext4";
    where = "/var/lib/longhorn";
    wantedBy = [ "k3s.service" ];
    requiredBy = [ "k3s.service" ];
    options = "noatime,discard";
  }];
}
