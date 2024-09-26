# module "gitlab_helm" {
#   source = "../helm_deployment"

#   chart           = "gitlab"
#   target_revision = "8.4.1"
#   repo_url        = "http://charts.gitlab.io/"

#   name             = "gitlab"
#   namespace        = "gitlab"
#   create_namespace = true

#   create_ingress = false

#   values = templatefile("${path.module}/templates/gitlab.yml.tpl", {

#   })
# }