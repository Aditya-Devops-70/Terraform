

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.INSTANCE_NAME}-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks-bluebird-dns"

  default_node_pool {
    name           = "${var.INSTANCE_NAME_PREFIX}np"
    node_count     = 1                #4
    vm_size        = "Standard_D2_v2" #D2as_v5              #"n2d-standard-2"
    vnet_subnet_id = azurerm_subnet.bluebird_subnet_1.id
    zones          = ["1", "2"] # Defining availability zones
    # Autoscaling settings
    auto_scaling_enabled = true
    min_count            = 1 #4
    max_count            = 1 #6
    # Availability Zones

  }

  #  zones = ["1", "2", "3"] # Defining availability zones

  identity {
    type = "SystemAssigned"
  }
  network_profile {
    network_plugin = "azure"
    #  network_policy    = "azure"
    load_balancer_sku   = "standard"
    network_plugin_mode = "overlay"
    pod_cidr            = "192.168.0.0/19"
    #  service_cidr = "192.168.2.0/21"
    #  outbound_type     = "userDefinedRouting"
  }
  private_cluster_enabled = true

  #  api_server_access_profile {
  #    authorized_ip_ranges = var.ENABLE_AKS_PUBLIC_ACCESS ? var.ALLOWED_AKS_PUBLIC_ACCESS_IP_RANGES : []
  #  }

  tags = {
    Environment = "dev"
  }
}




resource "azurerm_kubernetes_cluster_node_pool" "default_loads_nodes_pool" {
  name                  = "dfloadsnp"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "standard_b2ms" #D4as_v5                #"n2d-custom-4-8192"
  node_count            = 2               #1
  vnet_subnet_id        = azurerm_subnet.bluebird_subnet_1.id
  zones                 = ["1", "2"] # Defining availability zones
  auto_scaling_enabled  = true
  min_count             = 2 #1
  max_count             = 5 #3

  mode = "User" # Setting the node pool mode to System


  node_labels = {
    "environment" = "dev"
    "nodes_pool"  = "static"
  }

  tags = {
    Environment = "dev"
  }

}



resource "azurerm_kubernetes_cluster_node_pool" "dfx_worker_loads_nodes_pool" {
  name                  = "dfwoloanp"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_DS2_v2" #D4as_v5                #"n2d-custom-4-8192"
  node_count            = 2                 #1
  vnet_subnet_id        = azurerm_subnet.bluebird_subnet_1.id
  zones                 = ["1", "2"] # Defining availability zones
  auto_scaling_enabled  = true
  min_count             = 1 #1
  max_count             = 2 #3

  mode = "User" # Setting the node pool mode to System

  node_taints = [
    "nodes_pool=dfx_worker:NoSchedule"
  ]

  node_labels = {
    "environment" = "dev"
    "nodes_pool"  = "dfx_worker"
  }


  tags = {
    Environment = "dev"
  }

}






resource "azurerm_kubernetes_cluster_node_pool" "dfx_worker_loads_spot_nodes_pool" {
  name                  = "dfwlospotnp"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "standard_a2_v2" #D4as_v5                #"n2d-custom-4-8192"
  node_count            = 2                #2
  vnet_subnet_id        = azurerm_subnet.bluebird_subnet_1.id
  zones                 = ["1", "2"] # Defining availability zones
  auto_scaling_enabled  = true
  min_count             = 1 #2 
  max_count             = 2 #10

  mode = "User" # Setting the node pool mode to System

  node_taints = [
    "nodes_pool=dfx_worker:NoSchedule"
  ]

  node_labels = {
    "environment" = "dev"
    "nodes_pool"  = "dfx_worker"
  }

  tags = {
    Environment = "dev"
  }

}



resource "azurerm_kubernetes_cluster_node_pool" "api_loads_nodes_pool" {
  name                  = "apiloadsnp"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_DS2_v2" #D2as_v5                         # "n2d-standard-2"
  node_count            = 1                 #1
  vnet_subnet_id        = azurerm_subnet.bluebird_subnet_1.id
  zones                 = ["1", "2"] # Defining availability zones
  auto_scaling_enabled  = true
  min_count             = 1 #1
  max_count             = 2 #2

  mode = "User" # Setting the node pool mode to System

  node_taints = [
    "nodes_pool=api:NoSchedule"
  ]

  node_labels = {
    "environment" = "dev"
    "nodes_pool"  = "api"
  }

  tags = {
    Environment = "dev"
  }

}



resource "azurerm_kubernetes_cluster_node_pool" "api_loads_spot_nodes_pool" {
  name                  = "apiloadsspot"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_DS2_v2" #D2as_v5                      # "n2d-standard-2"
  node_count            = 1                 #1
  vnet_subnet_id        = azurerm_subnet.bluebird_subnet_1.id
  zones                 = ["1", "2"] # Defining availability zones
  auto_scaling_enabled  = true
  min_count             = 1 #1
  max_count             = 2 #6

  mode = "User" # Setting the node pool mode to System

  node_taints = [
    "nodes_pool=api:NoSchedule"
  ]

  node_labels = {
    "environment" = "dev"
    "nodes_pool"  = "api"
  }

  tags = {
    Environment = "dev"
  }

}


resource "azurerm_kubernetes_cluster_node_pool" "job_loads_nodes_pool" {
  name                  = "jobloadsnp"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "standard_a2_v2" #E8as_v5                         #"n2d-highmem-8"
  node_count            = 1                #0
  vnet_subnet_id        = azurerm_subnet.bluebird_subnet_1.id
  zones                 = ["1", "2"] # Defining availability zones
  auto_scaling_enabled  = true
  min_count             = 1 #0
  max_count             = 2 #3

  mode = "User" # Setting the node pool mode to System

  node_taints = [
    "nodes_pool=large:NoSchedule"
  ]

  node_labels = {
    "environment" = "dev"
    "nodes_pool"  = "job"
  }

  tags = {
    Environment = "dev"
  }

}




resource "azurerm_kubernetes_cluster_node_pool" "job_loads_spot_nodes_pool" {
  name                  = "jobloadsspot"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_DS2_v2" #E8as_v5                    #"n2d-highmem-8"
  node_count            = 1                 #0
  vnet_subnet_id        = azurerm_subnet.bluebird_subnet_1.id
  zones                 = ["1", "2"] # Defining availability zones
  auto_scaling_enabled  = true
  min_count             = 1 #0
  max_count             = 2 #10

  mode = "User" # Setting the node pool mode to System

  node_taints = [
    "nodes_pool=large:NoSchedule"
  ]

  node_labels = {
    "environment" = "dev"
    "nodes_pool"  = "job"
  }

  tags = {
    Environment = "dev"
  }

}




provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks.kube_config[0].host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
}




# output "kube_config" {
#   description = "The Kubernetes configuration for the AKS cluster."
#   value       = azurerm_kubernetes_cluster.aks.kube_config[0]
#   sensitive   = true
# }




provider "kubectl" {
  host = azurerm_kubernetes_cluster.aks.kube_config[0].host
  #  token                  = data.google_client_config.default.access_token
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
  load_config_file       = false
}






provider "helm" {
  kubernetes {
    host = azurerm_kubernetes_cluster.aks.kube_config[0].host
    #  token                  = data.google_client_config.default.access_token
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
  }
}




/*

resource "azurerm_role_assignment" "aks_contributor" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = "${data.azurerm_subscription.current.id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

*/