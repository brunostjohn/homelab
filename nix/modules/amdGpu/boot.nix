{ lib, ... }:

{
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
