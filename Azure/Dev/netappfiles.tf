
resource "azurerm_storage_account" "filestore" {
  name                       = "bluebirdfilestore70"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  account_tier               = "Premium"
  account_replication_type   = "LRS"         # Locally redundant storage, can be adjusted
  account_kind               = "FileStorage" # Required for NFS protocol
  https_traffic_only_enabled = false         # Required for NFS protocol

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["0.0.0.0/0"] #need to discuss with customer
    virtual_network_subnet_ids = [azurerm_subnet.bluebird_subnet_1.id]
    bypass                     = ["AzureServices"] # Allow trusted Azure services
  }
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_storage_share" "fileshare" {
  name               = "copa"
  storage_account_id = azurerm_storage_account.filestore.id
  quota              = 1024 # 1 TB quota in GB
  enabled_protocol   = "NFS"

}


# resource "azurerm_private_dns_zone" "bluebird_storage_dns_zone" {
#   name                = "bluebirdstorage.com"
#   resource_group_name = azurerm_resource_group.rg.name
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "bluebird_storage_azurerm_private_dns_zone_virtual_network_link" {
#   name                  = "link-to-vnet"
#   resource_group_name   = azurerm_resource_group.rg.name
#   private_dns_zone_name = azurerm_private_dns_zone.bluebird_storage_dns_zone.name
#   virtual_network_id    = azurerm_virtual_network.bluebird_vpc.id
# }


resource "azurerm_private_endpoint" "storage_pe" {
  name                = "bluebird-storage-pe"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.bluebird_subnet_1.id

  private_service_connection {
    name                           = "storage-connection"
    private_connection_resource_id = azurerm_storage_account.filestore.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }
}


# resource "azurerm_private_dns_a_record" "storage_a_record" {
#   name                = azurerm_storage_account.filestore.name
#   zone_name           = azurerm_private_dns_zone.bluebird_storage_dns_zone.name
#   resource_group_name = azurerm_resource_group.rg.name
#   ttl                 = 300
#   records             = [azurerm_private_endpoint.storage_pe.private_service_connection[0].private_ip_address]  #find out how to put ip here directly either dns
# }


output "private_ip" {
  value = azurerm_private_endpoint.storage_pe.private_service_connection[0].private_ip_address
}

# output "nfs" {
#   value = azurerm_storage_share.fileshare.url  
# }


/*

output "file_out" {
  value = azurerm_storage_share.filestore
}
*/





