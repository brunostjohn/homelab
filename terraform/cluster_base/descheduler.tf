module "descheduler" {
  source = "../helm_deployment"

  namespace        = "kube-system"
  create_namespace = false
  project          = argocd_project.cluster_mgmt.metadata[0].name

  name            = "descheduler"
  chart           = "descheduler"
  repo_url        = "https://kubernetes-sigs.github.io/descheduler"
  target_revision = "v0.30.1"

  create_ingress = false
}