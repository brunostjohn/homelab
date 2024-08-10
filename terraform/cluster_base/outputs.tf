output "homelab_repo" {
  value       = argocd_repository.homelab_github.repo
  description = "The URL of the homelab repository"
}

output "networking_project" {
  value       = argocd_project.networking.metadata[0].name
  description = "The name of the Networking project"
}

output "storage_project" {
  value       = argocd_project.storage.metadata[0].name
  description = "The name of the Storage project"
}

output "security_project" {
  value       = argocd_project.security.metadata[0].name
  description = "The name of the Security project"
}