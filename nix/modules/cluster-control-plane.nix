{ config, ... }:

{
  services.k3s.role = "server";
  services.k3s.extraFlags = "--disable servicelb --tls-san 10.0.2.22 --tls-san control-plane.k3s.local --etcd-expose-metrics true --node-name ${config.networking.hostName}.${config.networking.domain}";
  services.k3s.tokenFile = "/homelab-deploy/k3s-token";
}
