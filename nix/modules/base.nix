{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = with pkgs; [
    git
    iperf
    docker
    runc
  ];

  services.openssh.enable = true;

  security = { sudo.wheelNeedsPassword = false; };

  system.autoUpgrade.enable = true;

  system.stateVersion = "24.05";
}
