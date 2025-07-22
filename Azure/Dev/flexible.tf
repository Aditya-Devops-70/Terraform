


resource "random_password" "password" {
  length           = 8
  special          = true
  override_special = "!$*()-_"
}

resource "azurerm_postgresql_flexible_server" "sqldb" {
  name                          = "bluebird-postgresql-new" #only dash is aloud
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  version                       = "14"
  administrator_login           = "bluebird"
  administrator_password        = random_password.password.result
  sku_name                      = "GP_Standard_D2ds_v5" #use accordingly as per requirement
  storage_mb                    = 32768
  storage_tier                  = "P30"
  auto_grow_enabled             = true
  backup_retention_days         = 7
  zone                          = "1"
  public_network_access_enabled = false # **Ensure public network access is disabled like GCP's private IP setup**
  high_availability {
    mode                      = "ZoneRedundant"
    standby_availability_zone = "2"
  }
}

# Note:
# public_network_access_enabled must be set to false when delegated_subnet_id and private_dns_zone_id have a value.


resource "azurerm_postgresql_flexible_server_database" "bluebird_dp" {
  name      = "bluebird_dp"
  server_id = azurerm_postgresql_flexible_server.sqldb.id
  charset   = "UTF8"
  collation = "en_US.utf8" #use according your requirement 
}

resource "azurerm_postgresql_flexible_server_database" "temporal" {
  name      = "temporal"
  server_id = azurerm_postgresql_flexible_server.sqldb.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}


resource "azurerm_postgresql_flexible_server_database" "temporal_visibility" {
  name      = "temporal_visibility"
  server_id = azurerm_postgresql_flexible_server.sqldb.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}


resource "azurerm_postgresql_flexible_server_database" "boxyhq" {
  name      = "boxyhq"
  server_id = azurerm_postgresql_flexible_server.sqldb.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "azurerm_postgresql_flexible_server_database" "authz" {
  name      = "authz"
  server_id = azurerm_postgresql_flexible_server.sqldb.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}




resource "azurerm_postgresql_flexible_server_configuration" "max_connections" {
  name      = "max_connections"
  value     = "200"
  server_id = azurerm_postgresql_flexible_server.sqldb.id
}


# needs to be on
resource "azurerm_postgresql_flexible_server_configuration" "require_secure_transport" {
  name      = "require_secure_transport"
  value     = "OFF"
  server_id = azurerm_postgresql_flexible_server.sqldb.id
}

resource "azurerm_private_endpoint" "postgresql_pe" {
  name                = "${var.INSTANCE_NAME}-postgresql-pe"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.bluebird_subnet_1.id

  private_service_connection {
    name                           = "${var.INSTANCE_NAME}-postgresql-pe-connection"
    private_connection_resource_id = azurerm_postgresql_flexible_server.sqldb.id
    is_manual_connection           = false
    subresource_names              = ["postgresqlServer"]
  }

}

output "postgresql_flexible_server_private_endpoint_ip" {
  value = azurerm_private_endpoint.postgresql_pe.private_service_connection[0].private_ip_address
}



