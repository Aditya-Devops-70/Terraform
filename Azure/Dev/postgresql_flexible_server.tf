/*
resource "azurerm_private_dns_zone" "flexible_dns_zone_postgres" {
  name                = "bluebirdflexible.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "bluebird_private_dns_zone_network_link" {
  name                  = "bluebird-pdzvnetlink.com"
  private_dns_zone_name = azurerm_private_dns_zone.flexible_dns_zone_postgres.name
  virtual_network_id    = azurerm_virtual_network.bluebird_vpc.id
  resource_group_name   = azurerm_resource_group.rg.name
}

resource "random_password" "flexible_server_password" {
  length           = 8
  special          = true
  override_special = "!$*()-_"
}

resource "azurerm_postgresql_flexible_server" "bluebird_flexible_server" {
  name                          = "bluebird-psqlflexible-server"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  version                       = "13"
  delegated_subnet_id           = azurerm_subnet.bluebird_subnet_1.id
  private_dns_zone_id           = azurerm_private_dns_zone.flexible_dns_zone_postgres.id
  public_network_access_enabled = false
  administrator_login           = "bluebird"
  administrator_password        = random_password.flexible_server_password.result
  zone                          = "1"
  storage_mb   = 32768
  storage_tier = "P30"    
  # Backup Configuration
  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true          
  sku_name   = "GP_Standard_D4s_v3"

}

/*
resource "azurerm_private_endpoint" "flexible_endpoint" {
  name                = "bluebird-postgresql-flexible"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.bluebird_subnet_1.id

  private_service_connection {
    name                           = "bluebird-postgresql-psc"
    private_connection_resource_id = azurerm_postgresql_flexible_server.bluebird_flexible_server.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }

    private_dns_zone_group {
    name                 = azurerm_postgresql_flexible_server.bluebird_flexible_server.name
    private_dns_zone_ids = [azurerm_private_dns_zone.flexible_dns_zone_postgres.id]
  }

  depends_on = [azurerm_postgresql_flexible_server.bluebird_flexible_server, azurerm_subnet.bluebird_subnet_1]
}
*/

# Additional Databases in Azure

/*

resource "azurerm_postgresql_database" "bluebird_dp_new" {
  name                = "bluebird_dp"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_flexible_server.bluebird_flexible_server.name
  charset             = "UTF8"
  collation           = "en-US"
}

*/

/*


resource "azurerm_postgresql_database" "temporal" {
  name                = "temporal"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_flexible_server.bluebird_flexible_server.name
  charset             = "UTF8"
  collation           = "en_US.UTF8"
}


resource "azurerm_postgresql_database" "temporal_visibility" {
  name                = "temporal_visibility"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_flexible_server.bluebird_flexible_server.name
  charset             = "UTF8"
  collation           = "en_US.UTF8"
}


resource "azurerm_postgresql_database" "boxyhq" {
  name                = "boxyhq"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_flexible_server.bluebird_flexible_server.name
  charset             = "UTF8"
  collation           = "en_US.UTF8"
}

resource "azurerm_postgresql_database" "authz" {
  name                = "authz"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_flexible_server.bluebird_flexible_server.name
  charset             = "UTF8"
  collation           = "en_US.UTF8"
}

*/

