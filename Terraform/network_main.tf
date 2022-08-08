# Create the network VNET
resource "azurerm_virtual_network" "mediavnet" {
  name 				  = var.mediavnet
  address_space 	  = [var.mediavnetcidr]
  location            = azurerm_resource_group.mediarg.location
  resource_group_name = azurerm_resource_group.mediarg.name
}

# Create a subnet for VMSS appservers
resource "azurerm_subnet" "appvmsubnet" {
  name 					= var.mediaappsubnet
  address_prefixes 		= [var.mediaappsubnetcidr]
  resource_group_name   = azurerm_resource_group.mediarg.name
  virtual_network_name = azurerm_virtual_network.mediavnet.name
}

# Create a subnet for DB VM
resource "azurerm_subnet" "dbvmsubnet" {
  name 					= var.mediadbsubnet
  address_prefixes 		= [var.mediadbsubnetcidr]
  resource_group_name   = azurerm_resource_group.mediarg.name
  virtual_network_name = azurerm_virtual_network.mediavnet.name
}

# Get a Static Public IP
resource "azurerm_public_ip" "lbpublicip" {
   name                         = var.lbpublicipname
   location                     = azurerm_resource_group.mediarg.location
   resource_group_name          = azurerm_resource_group.mediarg.name
   allocation_method            = "Static"
}

 resource "azurerm_lb" "mediaapplb" {
   name                = var.mediaapplbname
   location            = azurerm_resource_group.mediarg.location
   resource_group_name = azurerm_resource_group.mediarg.name

   frontend_ip_configuration {
     name                 = "frontpubip"
     public_ip_address_id = azurerm_public_ip.lbpublicip.id
   }
 }

 resource "azurerm_lb_backend_address_pool" "lbappbp" {
   loadbalancer_id     = azurerm_lb.mediaapplb.id
   name                = var.lbappbpname
 }

 resource "azurerm_lb_nat_pool" "lbnatpool" {
  resource_group_name            = azurerm_resource_group.mediarg.name
  name                           = "ssh"
  loadbalancer_id                = azurerm_lb.mediaapplb.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "frontpubip"
}

resource "azurerm_lb_probe" "lbprobe" {
  resource_group_name = azurerm_resource_group.mediarg.name
  loadbalancer_id     = azurerm_lb.mediaapplb.id
  name                = "http-probe"
  protocol            = "Http"
  request_path        = "/health"
  port                = 8080
}


 resource "azurerm_network_interface" "dbvmnic" {
   name                = "dbvmnic"
   location            = azurerm_resource_group.mediarg.location
   resource_group_name = azurerm_resource_group.mediarg.name

   ip_configuration {
     name                          = "dbvmcconfig"
     subnet_id                     = azurerm_subnet.dbvmsubnet.id
     private_ip_address_allocation = "static"
   }
 }