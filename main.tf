variable "app_code" {}
variable "ips_allowed" {}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.app_code}"
  location = "West Europe"
}

# resource "azurerm_virtual_network" "vnet" {
#   name                = "vnet-${var.app_code}"
#   address_space       = ["10.0.0.0/16"]
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
# }

# resource "azurerm_subnet" "subnet" {
#   name                 = "snet-${var.app_code}"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.2.0/24"]
#   service_endpoints    = ["Microsoft.Storage"]
# }

resource "azurerm_storage_account" "stg" {
  name                = "storage123"
  resource_group_name = azurerm_resource_group.rg.name

  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

#   network_rules {
#     default_action             = "Deny"
#     ip_rules                   = ["122.161.112.118"] #copied ipaddress of my computer 
#     virtual_network_subnet_ids = [azurerm_subnet.subnet.id]
#   }

#converting network rules block as below

dynamic "network_rules" {
  for_each = var.ips_allowed == null ? {} : {key = "1"}
  content {
    default_action             = "Deny"
    ip_rules                   = var.ips_allowed
  }
}
}


