#data "azurerm_client_config" "current" {}

resource "random_password" "boxyhq-api-key" {
  length           = 8
  special          = true
  override_special = "!$*()-_"
}

resource "random_password" "boxyhq-nextauth-secret" {
  length           = 8
  special          = true
  override_special = "!$*()-_"
}


resource "random_password" "boxyhq-admin-credentials" {
  length           = 8
  special          = true
  override_special = "!$*()-_"
}


resource "random_password" "boxyhq-jackson-secrets" {
  length           = 8
  special          = true
  override_special = "!$*()-_"
}

resource "random_password" "centrifugo_api_key" {
  length           = 16
  special          = true
  override_special = "!$*()-_"
}

resource "random_password" "centrifugo_admin_secret" {
  length           = 8
  special          = true
  override_special = "!$*()-_"
}

resource "random_password" "centrifugo_admin_password" {
  length           = 8
  special          = true
  override_special = "!$*()-_"
}

resource "random_password" "centrifugo_hmac_secret" {
  length           = 8
  special          = true
  override_special = "!$*()-_"
}



#data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "backend-secret" {
  name                       = "backend-secret"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
}

resource "azurerm_key_vault_secret" "backend-secret-version" {
  name = "backend-secret-version"
  value = base64encode(jsonencode({
    "sql.password"              = random_password.password.result,
    "boxy.api-key"              = random_password.boxyhq-api-key.result,
    "box.next-auth-secret"      = random_password.boxyhq-nextauth-secret.result,
    "boxy.admin-credentials"    = random_password.boxyhq-admin-credentials.result,
    "boxy.jackson-secrets"      = random_password.boxyhq-jackson-secrets.result,
    "centrifugo.hmac-secret"    = random_password.centrifugo_hmac_secret.result,
    "centrifugo.api-key"        = random_password.centrifugo_api_key.result,
    "centrifugo.admin-password" = random_password.centrifugo_admin_password.result,
    "centrifugo.admin-secret"   = random_password.centrifugo_admin_secret.result,
    #    "gcp-service-account-key"   = google_service_account_key.bluebird-sa_key.private_key
  }))
  key_vault_id = azurerm_key_vault.backend-secret.id
}


/*

resource "azurerm_role_assignment" "kv_secrets_user" {
  principal_id   = data.azurerm_client_config.current.object_id
  role_definition_name = "Key Vault Secrets User"
  scope           = azurerm_key_vault.backend-secret.id
}

*/


resource "azurerm_key_vault" "k8s-secrets" {
  name                       = "k8s-secrets-blu"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
}


resource "azurerm_key_vault_secret" "k8s-secret-version" {
  name = "k8s-secret-version"
  value = base64encode(jsonencode({
    #   "k8s.bluebird-admin-sa-token" = kubernetes_secret.bluebird-admin-token.data.token               #it needs to be checked from where we take this token
  }))
  key_vault_id = azurerm_key_vault.k8s-secrets.id
}



resource "azurerm_key_vault" "connector-creds" {
  name                       = "conne-creds"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
}


resource "azurerm_key_vault_secret" "connector_creds_version" {
  name         = "con-cre-vers"
  value        = base64encode(jsonencode({})) # Empty object as in the original GCP example
  key_vault_id = azurerm_key_vault.connector-creds.id
  lifecycle {
    ignore_changes = [
      value # Ignore changes to the secret value
    ]
  }
  depends_on = [
    azurerm_key_vault.connector-creds
  ]
}



resource "azurerm_key_vault" "connector-creds-authz" {
  name                       = "con-cred-aut"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
}



resource "azurerm_key_vault_secret" "connector_creds_authz_version" {
  name         = "con-cre-auv"
  value        = base64encode(jsonencode({})) # Empty JSON object, as in the GCP version
  key_vault_id = azurerm_key_vault.connector-creds-authz.id
  lifecycle {
    ignore_changes = [
      value # Ignore changes to the secret value
    ]
  }
  depends_on = [
    azurerm_key_vault.connector-creds-authz
  ]
}





#note -

#Secret Access Policies: You may also want to configure access policies for your Key Vault to control who can access the secrets. 
#Use azurerm_key_vault_access_policy to set up access control.


/*
resource "azurerm_key_vault_access_policy" "example" {
  key_vault_id = azurerm_key_vault.example.id
  tenant_id    = "your-tenant-id"
  object_id    = "user-or-app-object-id"

  secret_permissions = [
    "get",
    "list",
  ]
}
*/

