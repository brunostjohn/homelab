{ pkgs, config, ... }:

let
  package = config.boot.kernelPackages.nvidiaPackages.stable;
in
{
  imports = [
    ./boot.nix
    ./containers.nix
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    package = pkgs.nvidia-patch.patch-nvenc (pkgs.nvidia-patch.patch-fbc package);
  };
}
