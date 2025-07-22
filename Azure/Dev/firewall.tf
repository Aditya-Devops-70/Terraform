
#################################################  Firewall-rule  ####################################################


resource "azurerm_public_ip" "pip_azfw" {
  name                = "pip-azfw"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# resource "azurerm_firewall_policy" "firewall_policy" {
#   name                = "azfw-policy"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   sku                      = "Standard"
#   threat_intelligence_mode = "Alert"
#   dns {
#     proxy_enabled = true
#   }
# }

resource "azurerm_firewall" "fw" {
  name                = "azfw"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  dns_proxy_enabled = true
  ip_configuration {
    name                 = "azfw-ipconfig"
    subnet_id            = azurerm_subnet.azfw_subnet.id
    public_ip_address_id = azurerm_public_ip.pip_azfw.id
  }
}

resource "azurerm_firewall_application_rule_collection" "aksfwar" {
  name                = "aksfwar"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = azurerm_resource_group.rg.name
  priority            = 100
  action              = "Allow"

  rule {
    name = "fqdn"
    source_addresses = [
      "*",
    ]  
    fqdn_tags = [
      "AzureKubernetesService"
    ]  
  }
}

resource "azurerm_firewall_application_rule_collection" "aksfwarweb" {
  name                = "aksfwarweb"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = azurerm_resource_group.rg.name
  priority            = 101
  action              = "Allow"

  rule {
    name = "storage"

    source_addresses = [
      "10.128.10.0/24",
    ]

    target_fqdns = [
      "*.blob.storage.azure.net",
      "*.blob.core.windows.net",
    ]
    protocol {
      port = "443"
      type = "Https"
    }
  }

  rule {
    name = "website"

    source_addresses = [
      "10.128.10.0/24",
    ]

    target_fqdns = [
       "ghcr.io",
       "*.docker.io",
       "*.docker.com",
       "*.githubusercontent.com",
    ]
    protocol {
      port = "443"
      type = "Https"
    }
  }

    rule {
    name = "bluebird-image"

    source_addresses = [
      "10.128.10.0/24",
    ]

    target_fqdns = [
      "pkg.dev",
      "ghcr.io",
      "pkg-containers.githubusercontent.com",
      "quay.io",
      "cdn01.quay.io",
      "cdn02.quay.io",
      "cdn03.quay.io",
      "cdn04.quay.io",
      "docker.io",
      "kedacore.github.io",
      "*.github.io"
    ]
    protocol {
      port = "443"
      type = "Https"
    }
  }

    rule {
    name = "container-image"

    source_addresses = [
      "0.0.0.0/0",
    ]

    target_fqdns = var.ALLOWED_CONTAINER_REGISTRIES
   
    protocol {
      port = "443"
      type = "Https"
    }
  }


}


resource "azurerm_firewall_network_rule_collection" "aksfwnr" {
  name                = "aksfwnr"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = azurerm_resource_group.rg.name
  priority            = 100
  action              = "Allow"

  rule {
    name = "apitcp"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "9000","8080-8090","443"
    ]

    destination_addresses = [
      "AzureCloud.centralindia"
    ]

    protocols = [
      "TCP",
    ]
  }

    rule {
    name = "apiudp"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "1194",
    ]

    destination_addresses = [
      "AzureCloud.centralindia"
    ]

    protocols = [
      "UDP",
    ]
  }
  
     rule {
    name = "time"
    source_addresses = [
      "*",
    ]
    destination_fqdns = [
    "ntp.ubuntu.com",
   ]
    destination_ports = [
    "123"
   ]   
    protocols = [
      "UDP",
    ]
  }


}

#################################### Attached firewall policy to subnets #################################################################

##To ensure that traffic from the AKS subnet flows through the Azure Firewall, you need to define a User-Defined Route (UDR).

# Route Table for Redirecting Traffic through the Firewall
resource "azurerm_route_table" "bluebird_route_table" {
  name                = "aks-route-table"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  bgp_route_propagation_enabled = true
  
  route {
    name                   = "route-to-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.fw.ip_configuration[0].private_ip_address
  }
  route {
    name                   = "route-to-internet"
    address_prefix         = "${azurerm_public_ip.pip_azfw.ip_address}/32"
    next_hop_type          = "Internet"
  }
}


resource "azurerm_subnet_route_table_association" "associate_to_main_subnet" {
  subnet_id      = azurerm_subnet.bluebird_subnet_1.id
  route_table_id = azurerm_route_table.bluebird_route_table.id
}

################################################################################################################################




# Possible Issues:
# Unintended Blocking: If the NSG blocks traffic from certain sources or IP addresses, the firewall's FQDN-based rules will not have a chance to inspect that traffic.
# Redundant Rules: If the same traffic is allowed by the NSG but blocked by the FQDN-based rules, or vice versa, this could lead to inconsistent or unintended access behavior. 
# In particular, if an NSG rule allows traffic on a certain port but the FQDN firewall rule blocks it based on the destination domain, there could be confusion about what traffic is being allowed.
