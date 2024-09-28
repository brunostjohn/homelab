{ pkgs, ... }:

{
  imports = [
    ./boot.nix
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;

    # extraPackages = with pkgs; [
    #   rocmPackages.clr.icd
    #   rocmPackages.clr
    # ];
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  # systemd.tmpfiles.rules = [
  #   "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  # ];

  environment.systemPackages = with pkgs; [
    clinfo
    # rocmPackages.rocminfo
    # rocmPackages.rocm-runtime
    # rocmPackages.rocm-smi
  ];

  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
  };

  hardware.amdgpu.opencl.enable = true;
  # hardware.amdgpu.initrd.enable = true;
}
