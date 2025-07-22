variable "machine_name" {}
variable "machine_type" {}
variable "image_family" {}
variable "image_project" {}
variable "network" {}
variable "subnetwork" {}
variable "zone" {}


variable "boot_disk_size_gb" {
  description = "Size of the boot disk in GB"
  type        = number
}

variable "assign_public_ip" {
  description = "Whether to assign a public IP"
  type        = bool
}

