{ pkgs, ... }:

{
  hardware.nvidia-container-toolkit.enable = true;

  virtualisation = {
    containers = { enable = true; };
    docker = {
      enable = true;
      package = pkgs.docker_25;
      daemon.settings.features.cdi = true;
    };
    oci-containers.backend = "docker";
  };

  services.k3s = {
    enable = true;
    role = "server";
    clusterInit = true;
    extraFlags = "--disable servicelb";
  };
}
