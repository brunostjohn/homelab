output "homelab_repo" {
  value       = argocd_repository.homelab_github.repo
  description = "The URL of the homelab repository"
}