variable "region" {
  description = "Region for Artifact Registry"
  type        = string
}

variable "repo_id" {
  description = "Artifact Registry Repository ID"
  type        = string
}

variable "environment" {
  description = "Environment tag (e.g., dev, prod)"
  type        = string
}
