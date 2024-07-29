{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./users.nix
    ./i18n.nix
    ./pool.nix
    ./containers.nix
    ./gpu.nix
    ./shares.nix
    ./metrics.nix
    ./ci.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    iperf
    docker
    runc
    ansible
    (wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    })
    terraform
  ];

  services.openssh.enable = true;

  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  security = { sudo.wheelNeedsPassword = false; };

  system.autoUpgrade.enable = true;

  system.stateVersion = "24.05";
}
