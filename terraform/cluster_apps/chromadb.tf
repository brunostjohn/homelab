module "chroma_helm" {
  source = "../helm_deployment"

  chart           = "chromadb"
  repo_url        = "https://amikos-tech.github.io/chromadb-chart/"
  target_revision = "0.1.20"
  values = templatefile("${path.module}/templates/chromadb.yml.tpl", {
    auth_token = var.chromadb_auth_token
  })

  namespace        = kubernetes_namespace.ai.metadata[0].name
  name             = "chromadb"
  create_namespace = false

  create_ingress = false
}
