{ node, ... }:

{
  services.qemuGuest.enable = true;
  systemd.network.links."10-lan" = {
    linkConfig.Name = "lan0";
    matchConfig.PermanentMACAddress = node.macAddress;
  };
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
