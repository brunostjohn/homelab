{ pkgs, config, ... }:

{
  hardware.nvidia-container-toolkit.enable = true;

  virtualisation = {
    containers = { enable = true; };
    docker = {
      enable = true;
      package = pkgs.docker_25;
      daemon.settings.features.cdi = true;
      logDriver = "json-file";
    };
    oci-containers.backend = "docker";
  };

  services.k3s = {
    enable = true;
    role = "server";
    clusterInit = true;
    extraFlags = "--disable servicelb";
  };

  services.openiscsi = {
    enable = true;
    name =
      "s1.nixos.nodes.zefirscloud.local.iscsi:${config.networking.hostName}";
  };

  systemd.tmpfiles.rules =
    [ "L+ /usr/local/bin - - - - /run/current-system/sw/bin/" ];
}
