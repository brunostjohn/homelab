{
  fileSystems."/mnt/jabberwock" = {
    device = "10.0.3.1:/mnt/jabberwock";
    fsType = "nfs";
  };

  fileSystems."/mnt/floofpool" = {
    device = "10.0.3.5:/mnt/floofpool";
    fsType = "nfs";
  };
}
