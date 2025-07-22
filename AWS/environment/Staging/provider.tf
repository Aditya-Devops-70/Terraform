provider "aws" {
  region     = var.region
  access_key = ""
  secret_key = ""
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.59.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.16.1"
    }
  }
    required_version = "~> 1.3"  
}


# terraform {
#   backend "s3" {
#     bucket = "knex-tfstates-prod"
#     key    = "prod-tfstate"
#     region = "ap-south-1"
#   }
# }