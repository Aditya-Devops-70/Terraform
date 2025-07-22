

resource "azurerm_storage_account" "stage_out" {
  name                     = var.bucket_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["0.0.0.0/0"] #need to discuss with customer
    virtual_network_subnet_ids = [azurerm_subnet.bluebird_subnet_1.id]
  }

  identity {
    type = "SystemAssigned"
  }

  blob_properties {
    versioning_enabled = true

    # CORS settings
    cors_rule {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET", "HEAD", "PUT", "POST", "DELETE"]
      allowed_origins    = ["*"]
      exposed_headers    = ["*"]
      max_age_in_seconds = 3600
    }
  }

}
# custom encryption for storage account 

/*
resource "azurerm_storage_encryption_scope" "storage_encryption" {
  name               = "bluebirdstorageencryption"
  storage_account_id = azurerm_storage_account.stage_out.id
  source             = "Microsoft.KeyVault"
  key_vault_key_id = azurerm_key_vault_key.storage_key.id
  depends_on = [ azurerm_key_vault_key.storage_key ]
}
*/

# Create Blob Containers within the Storage Accounts
resource "azurerm_storage_container" "stage_out_container" {
  name                  = "stageoutbucket"
  storage_account_id    = azurerm_storage_account.stage_out.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "log_bucket_container" {
  name                  = "logbucket"
  storage_account_id    = azurerm_storage_account.stage_out.id
  container_access_type = "private"
}


# Assign IAM-like role to a service principal for the stage-out container
resource "azurerm_role_assignment" "stage_out_admin" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = "${data.azurerm_subscription.current.id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = azurerm_storage_account.stage_out.identity[0].principal_id
}


