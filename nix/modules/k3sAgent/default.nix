{ config, ... }:

{
  services.k3s = {
    enable = true;
    role = "agent";
    tokenFile = /deploy/clustertoken;
    serverAddr = "https://10.0.2.22:6443";
    extraFlags = "--node-name ${config.networking.hostName}.${config.networking.domain}";
  };
}
