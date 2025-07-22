/*



output "resource_group_name" {                                      #resource group
  description = "The name of the created resource group."
  value       = azurerm_resource_group.rg.name
}

output "virtual_network_name" {                                     #Vnet
  description = "The name of the created virtual network."
  value       = azurerm_virtual_network.bluebird_vpc.name
}

output "subnet_name_1" {                                             #subnet
  description = "The name of the created subnet 1."
  value       = azurerm_subnet.bluebird_subnet_1.name
}




*/









#output "subnet_name_2" {
#  description = "The name of the created subnet 2."
#  value       = azurerm_subnet.my_terraform_subnet_2.name
#}


############################################################################################################################################################

/*
output "service_principal_name" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = azuread_service_principal.main.display_name
}

output "service_principal_object_id" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = azuread_service_principal.main.object_id
}

output "service_principal_tenant_id" {
  value = azuread_service_principal.main.application_tenant_id
}

output "service_principal_application_id" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = azuread_service_principal.main.application_id
}

output "client_id" {
  description = "The application id of AzureAD application created."
  value       = azuread_application.main.application_id
}

output "client_secret" {
  description = "Password for service principal."
  value       = azuread_service_principal_password.main.value
 
}

*/





###########################################################################################################################################################

/*
output "postgresql_server_password" {
  value     = random_password.password.result
  sensitive = true
}  */



# output "nfs_storage" {
#   value = azurerm_storage_share.filestore   
# }




# output "node_resource_group" {
#   value = azurerm_kubernetes_cluster.aks.node_resource_group
# }
