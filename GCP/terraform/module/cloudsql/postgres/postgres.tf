resource "google_project_service" "enable_sql" {
  service = "sqladmin.googleapis.com"
  project = var.project_id
}

resource "google_project_service" "enable_networking" {
  service = "servicenetworking.googleapis.com"
  project = var.project_id
}

resource "google_compute_global_address" "private_ip_range" {
  name          = "cloudsql-ip-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.db_private_network
  project       = var.project_id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.db_private_network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]
  depends_on              = [google_project_service.enable_networking]
}



resource "google_sql_database_instance" "postgres_instance" {
  name             = var.db_instance_name
  project          = var.project_id
  region           = var.region
  database_version = var.db_version

  settings {
    tier = var.db_tier
    disk_size   = var.disk_size
    disk_type   = var.disk_type
    edition = "ENTERPRISE"

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.db_private_network
    }
  }

  deletion_protection = false
    depends_on = [
    google_project_service.enable_sql,
    google_service_networking_connection.private_vpc_connection
  ]
}



resource "google_sql_user" "test_users" {
  name     = var.db_user
  instance = google_sql_database_instance.postgres_instance.name
  password = var.db_password
  project  = var.project_id
}

resource "google_sql_database" "test_db" {
  name     = var.db_name
  instance = google_sql_database_instance.postgres_instance.name
  project  = var.project_id
}
