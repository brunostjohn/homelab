{ pkgs, config, node, ... }:

{
  imports = [
    (import ./networking.nix { inherit node; })
    (import ./virtualMachine.nix { inherit node; })
    ./nixSettings.nix
    (import ./users.nix { inherit pkgs; })
    ./i18n.nix
    ./mounts.nix
  ];

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    git
    docker
    runc
    nfs-utils
    openiscsi
  ];

  virtualisation.docker.enable = true;

  services.openiscsi = {
    enable = true;
    name = "${config.networking.hostName}.${config.networking.domain}-initiatorhost";
  };

  environment.variables = {
    K3S_NODE_NAME = "${config.networking.hostName}.${config.networking.domain}";
  };

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "24.05";
}
