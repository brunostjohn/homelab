{ config, pkgs, nodeType, nodeMacAddress, nodeStaticIp, nodeHostname, ... }:

{
  import = [
    (import ./k3s.nix { inherit pkgs config; })
    (import ./networking.nix { inherit nodeType nodeMacAddress nodeStaticIp nodeHostname; })
    ./remote-access.nix
  ];
}
