 resource "azurerm_resource_group" "mediarg" {
   name     = "mediarg"
   location = "West US 2"
 }
# Generate random password
resource "random_password" "linux-vm-password" {
  length           = 16
  min_upper        = 2
  min_lower        = 2
  min_special      = 2
  number           = true
  special          = true
  override_special = "!@#$%&"
}

resource "azurerm_virtual_machine" "dbvm" {
   count                 = 1
   name                  = "dbvm${count.index}"
   location              = azurerm_resource_group.mediarg.location   
   resource_group_name   = azurerm_resource_group.mediarg.name
   network_interface_ids = [element(azurerm_network_interface.dbvmnic.*.id, count.index)]
   vm_size               = "Standard_DS1_v2"

   # Uncomment this line to delete the OS disk automatically when deleting the VM
   delete_os_disk_on_termination = true

   # Uncomment this line to delete the data disks automatically when deleting the VM
   # delete_data_disks_on_termination = true
}
 resource "azurerm_virtual_machine_scale_set" "appvmss" {
  name                = "appwebvmss"
  location            = azurerm_resource_group.mediarg.location
  resource_group_name = azurerm_resource_group.mediarg.name

  # automatic rolling upgrade
  automatic_os_upgrade = true
  upgrade_policy_mode  = "Rolling"

  rolling_upgrade_policy {
    max_batch_instance_percent              = 50
    max_unhealthy_instance_percent          = 50
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT0S"
  }

  # required when using rolling upgrade policy
  health_probe_id = azurerm_lb_probe.example.id

   storage_profile_image_reference {
     publisher = var.webvm_image_publisher
     offer     = var.webvm_image_offer
     sku       = var.rhel_8_2_sku
     version   = "latest"
   }

   storage_profile_os_disk {
     name              = ""
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }

   
   os_profile {
  
  computer_name  = "appvm${count.index}"
  admin_username = var.linux_admin_username
  admin_password = random_password.linux-vm-password.result
   }

   os_profile_linux_config {
     disable_password_authentication = false
   }
network_profile {
    name    = "appvmnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "appvmconfig"
      primary                                = true
      subnet_id                              = azurerm_subnet.appvmsubnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lbappbp.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.lbnatpool.id]
    }
  }

   tags = {
     environment = "staging"
   }
 }