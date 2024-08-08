{ config, node, lib, pkgs, ... }:

{
  imports = [
    ./i18n.nix
    ./k3s.nix
    (import ./longhorn.nix { inherit config node; })
    ./metrics.nix
    (import ./networking.nix { inherit node; })
    (import ./nix-config.nix { inherit lib; })
    (import ./users.nix { inherit pkgs; })
    (import ./base.nix { inherit pkgs; })
  ];
}
