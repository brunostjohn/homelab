{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  services.qemuGuest.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  security.sudo.wheelNeedsPassword = false;

  fileSystems."/mnt/jabberwock" = {
    device = "10.0.3.1:/mnt/jabberwock";
    fsType = "nfs";
  };

  services.openiscsi = {
    enable = true;
    name = "${config.networking.hostName}.${config.networking.domain}-initiatorhost";
  };

  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = "--disable servicelb --tls-san 10.0.2.22 --tls-san control-plane.k3s.local --etcd-expose-metrics true --node-name ${config.networking.hostName}.${config.networking.domain}";
    tokenFile = /deploy/clustertoken;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.interfaces.lan0.ipv4.addresses = [
    {
      address = "10.0.0.2";
      prefixLength = 16;
    }
  ];
  networking.defaultGateway = "10.0.0.1";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  networking.hostName = "s1";
  networking.domain = "m-nodes.zefirscloud.local";
  systemd.network.links."10-lan" = {
    matchConfig.PermanentMACAddress = "bc:24:11:de:e6:94";
    linkConfig.Name = "lan0";
  };

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Dublin";

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
    openiscsi
    nfs-utils
    runc
    docker
  ];

  virtualisation.docker.enable = true;

  services.openssh.enable = true;

  networking.firewall.enable = false;

  system.stateVersion = "24.05";

  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };
}
