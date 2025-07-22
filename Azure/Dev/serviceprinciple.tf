/*

data "azuread_client_config" "current" {}

resource "azuread_application" "bluebird_application" {
  display_name = var.Service_application_name
  owners       = [data.azuread_client_config.current.object_id]

  depends_on = [azurerm_resource_group.rg]
}

resource "azuread_service_principal" "bluebird-spn" {
  client_id                    = azuread_application.bluebird_application.client_id
  app_role_assignment_required = true
  owners                       = [data.azuread_client_config.current.object_id]
}


resource "azuread_service_principal_password" "example" {
  service_principal_id = azuread_service_principal.bluebird-spn.id
}

*/