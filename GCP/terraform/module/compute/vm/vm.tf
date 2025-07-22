resource "google_compute_instance" "test_vm" {
  name         = var.machine_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "${var.image_project}/${var.image_family}"
      size  = var.boot_disk_size_gb
    }
  }

  network_interface {
  network    = var.network
  subnetwork = var.subnetwork

  dynamic "access_config" {
    for_each = var.assign_public_ip ? [1] : []
    content {
      // Creates public IP if assign_public_ip is true
    }
  }
 }
}

