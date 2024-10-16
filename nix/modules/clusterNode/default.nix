{ pkgs, node, ... }:

{
  imports = [
    (import ./networking.nix { inherit node; })
    (import ./virtualMachine.nix { inherit node; })
    ./nixSettings.nix
    (import ./users.nix { inherit pkgs; })
    ./i18n.nix
    ./mounts.nix
    ./boot.nix
  ];

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    git
    docker
    runc
    nfs-utils
    openiscsi
    python3
  ];

  virtualisation.docker.enable = true;

  services.openiscsi = {
    enable = true;
    name = "${node.hostname}.m-nodes.zefirscloud.local-initiatorhost";
  };

  environment.variables = {
    K3S_NODE_NAME = "${node.hostname}.m-nodes.zefirscloud.local";
  };

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "24.05";
}
