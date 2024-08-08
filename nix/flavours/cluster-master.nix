{ ... }:

{
  services.k3s = {
    clusterInit = true;
    extraFlags = "--disable servicelb";
  };
}
