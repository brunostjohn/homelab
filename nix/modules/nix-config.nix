{ lib, ... }:

{
  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  nixpkgs.config.allowUnfree = lib.mkForce true;
}
