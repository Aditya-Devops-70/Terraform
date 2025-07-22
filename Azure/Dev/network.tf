# Resource Group
resource "azurerm_resource_group" "rg" {
  location = "Central India"
  name     = "bluebirdDev"
}


# Virtual Network
resource "azurerm_virtual_network" "bluebird_vpc" {
  #  count               = var.CREATE_NETWORK ? 1 : 0  
  name                = "${var.INSTANCE_NAME}-vnet"
  address_space       = ["10.128.0.0/16", "192.168.0.0/18"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}




# Subnet 1
resource "azurerm_subnet" "bluebird_subnet_1" {
  #  count                = var.CREATE_NETWORK ? 1 : 0  
  name                 = var.subnet-1
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.bluebird_vpc.name
  address_prefixes     = ["10.128.10.0/24"] # You can change the range as per requirement
  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.Sql"
  ] # Add service endpoint for Microsoft.Storage

  private_endpoint_network_policies = "Enabled" # need to check 

  # delegation {
  #   name = "fs"

  #   service_delegation {
  #     name = "Microsoft.DBforPostgreSQL/flexibleServers"

  #     actions = [
  #       "Microsoft.Network/virtualNetworks/subnets/join/action",
  #     ]
  #   }
  # }


  depends_on = [
    azurerm_virtual_network.bluebird_vpc
  ]
}

# subnet 2
resource "azurerm_subnet" "azfw_subnet" {
  name                 = "AzureFirewallSubnet" #don't change the name it will required same for the firewall policy
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.bluebird_vpc.name
  address_prefixes     = ["10.128.12.0/24"]
}




# Subnet for Gateway (This is required for the VPN Gateway)
resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet" #don't change the name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.bluebird_vpc.name
  address_prefixes     = ["10.128.8.0/24"]
}