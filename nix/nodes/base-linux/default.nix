{ pkgs, ... }:

{
  import = [
    ./filesystems.nix
    ./containers.nix
    ./boot.nix
    ./filesystems.nix
    ./i18n.nix
    ./networking.nix
    (import ./users.nix { inherit pkgs; })
  ];

  system.stateVersion = "24.05";
}
