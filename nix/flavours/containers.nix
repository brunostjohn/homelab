{ pkgs, ... }:

{
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
}
