{ ... }:

{
  services.k3s = {
    enable = true;
  };

  services.openiscsi = {
    enable = true;
  };
}
