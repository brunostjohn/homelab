{ config, ... }:

{
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  boot.zfs.extraPools = [ "jabberwock" ];
  services.zfs = {
    trim.enable = true;
    autoScrub.enable = true;
  };
}
