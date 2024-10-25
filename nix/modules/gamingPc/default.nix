{ pkgs, lib, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kittycon";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Dublin";

  services.xserver.enable = true;
  security.sudo.wheelNeedsPassword = false;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # chaotic.hdr.enable = true;

  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.amdgpu.initrd.enable = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.getty.autologinUser = "brunostjohn";

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    gh
    git
    mangohud
  ];

  environment.loginShellInit = ''
    export MANGOHUD=1
    export STEAM_MULTIPLE_XWAYLANDS=1
    export MANGOHUD_CONFIG="$(IFS=,; echo "cpu_temp,gpu_temp,ram,vram")"

    [[ "$(tty)" = "/dev/tty1" ]] && gamescope --xwayland-count 2 --adaptive-sync -- steam -gamepadui -steamdeck"
  '';

  services.openssh.enable = true;

  networking.firewall.enable = false;

  boot.kernelPackages = pkgs.linuxPackages;

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  system.stateVersion = "24.05";
}
