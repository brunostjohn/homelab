{ pkgs }:

pkgs.mkShell {
  shellHook = ''
    alias tf=terraform
    alias k=kubectl
    alias t=task
  '';

  packages = with pkgs; [
    ansible
    terraform
    nil
    nixfmt-classic
    go-task
    kubectl
    caddy
    yamllint
    yamlfmt
    tflint
    envsubst
    kubetail
    fd
    cmctl
    argocd
    (wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    })
  ];
}
