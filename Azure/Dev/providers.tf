terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.13.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }

    # kubernetes = {
    #   source  = "hashicorp/kubernetes"
    #   version = ">= 2.0.0"
    # }
    # kubectl = {
    #   source  = "cpanato/kubectl"
    #   version = ">= 1.14.1"
    # }

  }
}

provider "azurerm" {
  subscription_id = ""
  client_id       = ""
  client_secret   = ""
  tenant_id       = ""

  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
    netapp {
      prevent_volume_destruction             = true
      delete_backups_on_backup_vault_destroy = false
    }
  }
  # Configuration options
}

