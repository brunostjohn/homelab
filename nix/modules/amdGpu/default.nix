{ ... }:

{
  imports = [
    ./boot.nix
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.amdgpu.initrd.enable = true;
}
