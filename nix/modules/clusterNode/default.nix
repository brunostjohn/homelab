{ pkgs, node, ... }:

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
    name = "${node.hostname}.m-nodes.zefirscloud.internal-initiatorhost";
  };

  environment.variables = {
    K3S_NODE_NAME = "${node.hostname}.m-nodes.zefirscloud.internal";
  };

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "24.05";
}
