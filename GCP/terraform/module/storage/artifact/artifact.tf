resource "google_artifact_registry_repository" "docker_repo" {
  provider      = google
  location      = var.region
  repository_id = var.repo_id
  description   = "Docker repo for storing container images"
  format        = "DOCKER"

  labels = {
    environment = var.environment
  }
}
