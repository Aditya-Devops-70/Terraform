
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key_vault" {
  name                            = "key-vault-bluebird-dev"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  enabled_for_disk_encryption     = true
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = 7
  purge_protection_enabled        = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true

  sku_name = "standard"

  #  depends_on = [
  #    azurerm_resource_group.resource_group
  #  ]
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Decrypt",
      "Encrypt",
      "UnwrapKey",
      "WrapKey",
      "Verify",
      "Sign",
      "Purge",
      "Release",
      "Rotate",
      "GetRotationPolicy",
      "SetRotationPolicy"
    ]

    secret_permissions = [
      "Get", "List", "Set",
    ]

    storage_permissions = [
      "Get", "List",
    ]
  }


  depends_on = [azurerm_resource_group.rg]

}

resource "azurerm_key_vault_key" "auth_key" {
  name         = "bluebird-dev-auth-key"
  key_vault_id = azurerm_key_vault.key_vault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  rotation_policy { #change accordingly your requirement 
    automatic {
      time_before_expiry = "P30D"
    }

    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }

  depends_on = [azurerm_key_vault.key_vault]

}












# add role to object id which is required using this block and object id will be different as per user
/*

resource "azurerm_role_assignment" "key_vault_reader" {
  principal_id   = data.azurerm_client_config.current.object_id
  role_definition_name = "Key Vault Administrator"
  scope           = azurerm_key_vault.key_vault.id
}

*/



resource "azurerm_key_vault_key" "refresh_key" {
  name         = "bluebird-dev-refresh-key"
  key_vault_id = azurerm_key_vault.key_vault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
  rotation_policy { #change accordingly your requirement 
    automatic {
      time_before_expiry = "P30D"
    }

    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }

  depends_on = [azurerm_key_vault.key_vault]

}


# this key use for storage to encrypt data at rest

/*
resource "azurerm_key_vault" "storage_key_vault" {
  name                       = "blu-storagekeyvault"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption  = true
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = true  # Enable Purge Protection to prevent permanent deletion

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_storage_account.stage_out.identity[0].principal_id

    key_permissions = [
    "Get",
    "List",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]

     storage_permissions = [
      "Get", "List",
    ]
  }
}

resource "azurerm_key_vault_key" "storage_key" {
  name         = "storage-key"
  key_vault_id = azurerm_key_vault.storage_key_vault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
    
  ]


rotation_policy {
    automatic {
    time_before_expiry = "P30D"  # Trigger rotation 30 days before expiry
    }
    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }

  depends_on = [azurerm_key_vault.storage_key_vault]

}

*/


/*

resource "azurerm_key_vault_access_policy" "object_get" {
  key_vault_id = azurerm_key_vault.storage_key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Decrypt",
    "Encrypt",
    "UnwrapKey",
    "WrapKey",
    "Verify",
    "Sign",
    "Purge",
    "Release",
    "Rotate",
    "GetRotationPolicy",
    "SetRotationPolicy"
  ]

  secret_permissions = [
    "Get",
  ]
}

*/


# Service Principal for RBAC (Simulating a Service Account in GCP)



#Azure Key Vault also supports key versioning, 
#but Terraform automatically manages this for you. When you create or update a key in Azure Key Vault, a new version is automatically generated. 
#However, Terraform does not require explicit handling of versions during creation or usage.



################################################################################################################################################

# key vault permission  for storage accouunt 
/*

resource "azurerm_role_assignment" "key_vault_admin" {
  principal_id   = data.azurerm_client_config.current.object_id
  role_definition_name = "Key Vault Administrator"
  scope           = azurerm_key_vault.key_vault.id
}

# Step 2: Assign Key Vault Contributor role to manage the Key Vault and its keys
resource "azurerm_role_assignment" "keyvault_contributor_role" {
  principal_id   = data.azurerm_client_config.current.object_id
  role_definition_name = "Key Vault Contributor"
  scope           = azurerm_key_vault.key_vault.id
}

# Step 3: Assign Key Vault Reader role to allow the Service Principal to read keys
resource "azurerm_role_assignment" "keyvault_reader_role" {
  principal_id   =  data.azurerm_client_config.current.object_id
  role_definition_name = "Key Vault Reader"
  scope           = azurerm_key_vault.key_vault.id
}

# Step 4: Assign Storage Account Contributor role to manage the storage account encryption
resource "azurerm_role_assignment" "storage_account_contributor_role" {
  principal_id   = data.azurerm_client_config.current.object_id
  role_definition_name = "Storage Account Contributor"
  scope           = azurerm_storage_account.stage_out.id
}

# permissions 

# Role-Based Access Control (RBAC) for the Managed Identity to allow "List" and privileged access
resource "azurerm_role_assignment" "key_vault_crypto_user" {
  principal_id         = azurerm_storage_account.stage_out.identity[0].principal_id
  role_definition_name = "Key Vault Crypto User"
  scope                = azurerm_key_vault.key_vault.id
}

resource "azurerm_role_assignment" "key_vault_reader" {
  principal_id         = azurerm_storage_account.stage_out.identity[0].principal_id
  role_definition_name = "Key Vault Reader"
  scope                = azurerm_key_vault.key_vault.id
}

*/