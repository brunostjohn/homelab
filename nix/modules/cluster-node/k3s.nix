{ pkgs, config, ... }:

{
  services.k3s = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    openiscsi
    nfs-utils
    runc
    docker
  ];

  services.openiscsi = {
    enable = true;
    name = "${config.networking.hostName}.${config.networking.domain}-initiatorhost";
  };
}
