

resource "random_password" "password" {
  length           = 8
  special          = true
  override_special = "!$*()-_"
}



resource "azurerm_postgresql_server" "postgresql_server" {
  name                = "bluebird-psqlserver7080"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  administrator_login          = "bluebird"
  administrator_login_password = random_password.password.result

  sku_name   = "GP_Gen5_4"
  version    = "11"
  storage_mb = 6144

  #   timeouts {
  #     create = "10m"
  #   }


  # Backup Configuration
  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  public_network_access_enabled    = false # **Ensure public network access is disabled like GCP's private IP setup**
  ssl_enforcement_enabled          = false
  ssl_minimal_tls_version_enforced = "TLSEnforcementDisabled"

  depends_on = [
    #google_project_service.cloudsql,
    #google_project_service.sqladmin,
    #google_service_networking_connection.private_vpc_connection,
    random_password.password
  ]


}


resource "azurerm_private_endpoint" "bluebird_private_endpoint" {
  name                = "bluebird-endpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.bluebird_subnet_1.id

  private_service_connection {
    name                           = "bluebird-privateserviceconnection"
    private_connection_resource_id = azurerm_postgresql_server.postgresql_server.id
    is_manual_connection           = false
    subresource_names              = ["postgresqlServer"] # Add this line
  }
}





# resource "azurerm_private_dns_zone" "bluebird_dns_zone" {
#   name                = "privatelink.postgres.database.azure.com"
#   resource_group_name = azurerm_resource_group.rg.name
# }


# resource "azurerm_private_dns_zone_virtual_network_link" "bluebird_dns" {
#   name                  = "bluebird-link"
#   resource_group_name   = azurerm_resource_group.rg.name
#   private_dns_zone_name = azurerm_private_dns_zone.bluebird_dns_zone.name
#   virtual_network_id    = azurerm_virtual_network.bluebird_vpc.id
# }




# Set Database Parameters (Max Connections)
resource "azurerm_postgresql_configuration" "max_connections" {
  name                = "max_connections"
  value               = "on"
  server_name         = azurerm_postgresql_server.postgresql_server.name
  resource_group_name = azurerm_resource_group.rg.name
}





# Additional Databases in Azure

resource "azurerm_postgresql_database" "bluebird_dp" {
  name                = "bluebird_dp"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  charset             = "UTF8"
  collation           = "en-US"
}

resource "azurerm_postgresql_database" "temporal" {
  name                = "temporal"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  charset             = "UTF8"
  collation           = "en-US"
}


resource "azurerm_postgresql_database" "temporal_visibility" {
  name                = "temporal_visibility"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  charset             = "UTF8"
  collation           = "en-US"
}


resource "azurerm_postgresql_database" "boxyhq" {
  name                = "boxyhq"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  charset             = "UTF8"
  collation           = "en-US"
}

resource "azurerm_postgresql_database" "authz" {
  name                = "authz"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  charset             = "UTF8"
  collation           = "en-US"
}


##In Azure, the equivalent of GCP's insights_config for PostgreSQL would be related to Azure Database for PostgreSQL #monitoring features. 
#Specifically, this can be achieved by configuring Diagnostic Settings and enabling Query Performance Insights.
#Azure does not have a direct equivalent of GCP's insights_config in the Terraform resources,  
#but you can achieve #similar monitoring configurations using Azure Monitor and Query Performance Insights for PostgreSQL.

# insight config is remaining 



output "sql-out" {
  sensitive = true
  value     = azurerm_postgresql_server.postgresql_server
}



output "private_endpoint_ip" {
  description = "The private endpoint IP address."
  value       = azurerm_private_endpoint.bluebird_private_endpoint
  sensitive   = false
}

output "db-password" {
  sensitive = true
  value     = azurerm_postgresql_server.postgresql_server.administrator_login_password

}



# reminder - check postgres connection from pods to database


 
 
output "private_endpoint_ip_db" {
  description = "The private endpoint IP address."
  value       = azurerm_private_endpoint.bluebird_private_endpoint.custom_dns_configs[0].ip_addresses[0]
  sensitive   = false
}
 
 output "hostname" {
  value = azurerm_postgresql_server.postgresql_server.name   
}
