{ pkgs, config, ... }:

{
  users.users.githubActionsUser = {
    isNormalUser = true;
    description = "GitHub Actions User";
    extraGroups = [ "wheel" "docker" "sudo" ];
    packages = with pkgs; [ git gawk openssh ];
  };

  services.github-runners.jabberwockRunner = {
    enable = true;
    name = "jabberwock-runner";
    tokenFile = "/mnt/jabberwock/githubactions/jabberwock-runner-secret";
    url = "https://github.com/brunostjohn/homelab";
    user = "githubActionsUser";
    extraPackages = with pkgs; [
      config.virtualisation.docker.package
      config.security.sudo.package
      git
      gawk
      openssh
      terraform
      ansible
      (wrapHelm kubernetes-helm {
        plugins = with pkgs.kubernetes-helmPlugins; [
          helm-secrets
          helm-diff
          helm-s3
          helm-git
        ];
      })
    ];
    serviceOverrides = {
      ReadWritePaths = [ "/mnt/jabberwock/caddy/Caddyfile" ];
      ReadWriteDirectories = [ "/homelab" ];
      ProtectHome = false;
    };
  };

  systemd.services.github-runner-jabberwockRunner.serviceConfig.SupplementaryGroups =
    [ "docker" ];
}
