{ config, ... }:

{
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = "--disable servicelb --tls-san 10.0.2.22 --tls-san control-plane.k3s.local --etcd-expose-metrics true --node-name ${config.networking.hostName}.${config.networking.domain}";
    tokenFile = /deploy/clustertoken;
    serverAddr = "https://10.0.0.2:6443";
  };
}
