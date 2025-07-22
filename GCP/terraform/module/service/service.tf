resource "google_service_account" "test" {
  account_id   = var.sa_name
  display_name = var.sa_display_name
}

resource "google_project_iam_member" "artifact_registry_admin" {
  project = var.project_id
  role    = "roles/artifactregistry.admin"
  member  = "serviceAccount:${google_service_account.test.email}"
}
