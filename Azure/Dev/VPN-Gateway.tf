# Public IP for the VPN Gateway
resource "azurerm_public_ip" "vpn_public_ip" {
  name                = "vpn-public-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  #  allocation_method   = "Dynamic"
  allocation_method = "Static"   # Change this to Static for Standard SKU
  sku               = "Standard" # Ensure the SKU is set to Standard
  zones             = ["1"]
}


resource "azurerm_public_ip" "gateway_zone_redundant2" {
  name                = "redeploymentgateway-pip-az2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}

resource "azurerm_public_ip" "gateway_zone_redundant3" {
  name                = "redeploymentgateway-pip-az3"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}


resource "azurerm_virtual_network_gateway" "vpn" {
  name                = "bluebird_vpn"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active              = true
  enable_bgp                 = false
  sku                        = "VpnGw2AZ"
  private_ip_address_enabled = false

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_public_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }

  ip_configuration {
    name                          = "vnetGatewayConfig1"
    public_ip_address_id          = azurerm_public_ip.gateway_zone_redundant2.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }

  ip_configuration {
    name                          = "vnetGatewayConfig2"
    public_ip_address_id          = azurerm_public_ip.gateway_zone_redundant3.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }


  # Point-to-Site VPN Configuration
  vpn_client_configuration {
    address_space        = ["172.168.2.0/27"] # need to change during terraform apply
    vpn_client_protocols = ["IkeV2", "OpenVPN"]
    vpn_auth_types       = ["Certificate"]

    root_certificate {
      name             = "root-cert"
      public_cert_data = filebase64("root-cert.pem")
    }
  }
}

