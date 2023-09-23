provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "myname" {
  count    = 3
  name     = "rgnew${count.index}"
  location = "eastus"
}

resource "azurerm_virtual_network" "myname" {
  name                = "vnet-test"
  location            = azurerm_resource_group.myname.location
  resource_group_name = azurerm_resource_group.myname.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "myname" {
  name                 = "subnet-test"
  virtual_network_name = azurerm_virtual_network.myname.name
  address_prefixes     = ["10.0.0.0/24"]
  #depends on vnet to created before creating subnet
  depends_on          = [azurerm_virtual_network.myname]
  resource_group_name = azurerm_resource_group.myname.name
}

resource "azurerm_network_interface" "myname" {
  name                = "nic-test"
  location            = azurerm_resource_group.myname.location
  resource_group_name = azurerm_resource_group.myname.name
  depends_on          = [azurerm_subnet.myname]
  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.myname.id
    private_ip_address_allocation = "Dynamic"
  }
}