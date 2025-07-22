

resource "azurerm_container_registry" "acr" {
  #  count               = var.CREATE_NETWORK ? 1 : 0  
  name                = var.containerregistry1
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Premium"
  admin_enabled       = false

  identity {
    type = "SystemAssigned"
  }

  # georeplications {
  #   location                = "East US"
  #   zone_redundancy_enabled = true
  #   tags                    = {}
  # }
  # georeplications {
  #   location                = "North Europe"
  #   zone_redundancy_enabled = true
  #   tags                    = {}
  # }
}

resource "azurerm_role_assignment" "acr_contributor" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = "${data.azurerm_subscription.current.id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = azurerm_container_registry.acr.identity[0].principal_id
}

