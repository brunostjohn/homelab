{ pkgs, ... }:

{
  imports = [
    ./boot.nix
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;

    extraPackages = with pkgs; [
      rocmPackages_5.clr.icd
      rocmPackages_5.clr
      rocmPackages_5.rocminfo
      rocmPackages_5.rocm-runtime
    ];
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages_5.clr}"
  ];

  environment.systemPackages = with pkgs; [
    clinfo
    rocmPackages_5.clr.icd
    rocmPackages_5.clr
    rocmPackages_5.rocminfo
    rocmPackages_5.rocm-runtime
  ];

  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
  };
}
