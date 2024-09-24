{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  services.qemuGuest.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "s2";
  networking.domain = "m-nodes.zefirscloud.local";
  networking.defaultGateway = "10.0.0.1";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  networking.interfaces.lan0.ipv4.addresses = [
    {
      address = "10.0.3.3";
      prefixLength = 16;
    }
  ];

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Dublin";

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
  };
  boot.initrd.kernelModules = [ "nvidia" ];
  boot.kernelParams = [ "nvidia-drm.fbdev=1" ];
  hardware.nvidia-container-toolkit.enable = true;

  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
  };

  services.openiscsi = {
    enable = true;
    name = "${config.networking.hostName}.${config.networking.domain}-initiatorhost";
  };

  services.k3s = {
    enable = true;
    role = "agent";
    tokenFile = /deploy/clustertoken;
    serverAddr = "https://10.0.0.2:6443";
    extraFlags = "--node-name s2.m-nodes.zefirscloud.local";
  };

  i18n.defaultLocale = "en_IE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  console.keyMap = "pl2";

  users.users.brunostjohn = {
    isNormalUser = true;
    description = "Bruno St John";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  services.getty.autologinUser = "brunostjohn";

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    docker
    runc
    nfs-utils
    openiscsi
  ];

  fileSystems."/mnt/jabberwock" = {
    fsType = "nfs";
    device = "10.0.3.1:/mnt/jabberwock";
  };

  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  security = { sudo.wheelNeedsPassword = false; };

  system.autoUpgrade.enable = true;

  services.openssh.enable = true;

  networking.firewall.enable = false;
  systemd.network.links."10-internet" = {
    matchConfig.PermanentMACAddress = "bc:24:11:fa:16:37";
    linkConfig.Name = "lan0";
  };

  system.stateVersion = "24.05";
}
