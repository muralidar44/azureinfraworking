 resource "azurerm_resource_group" "mediarg" {
   name     = "mediawikirg"
   location = "West US"
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
   vm_size               = "Standard_D4s_v3"

   # Uncomment this line to delete the OS disk automatically when deleting the VM
   delete_os_disk_on_termination = true

   # Uncomment this line to delete the data disks automatically when deleting the VM
   # delete_data_disks_on_termination = true
   storage_image_reference {
     publisher = "Canonical"
     offer     = "UbuntuServer"
     sku       = "18.04-LTS"
     version   = "latest"
   }

   storage_os_disk {
     name              = "myosdisk"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }

   
   os_profile {
     computer_name  = "hostname"
     admin_username = "testadmin"
     admin_password = "Password1234!"
   }

   os_profile_linux_config {
     disable_password_authentication = false
   }
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
  health_probe_id = azurerm_lb_probe.lbprobe.id
    sku {
    name     = "Standard_D4s_v3"
    tier     = "Standard"
    capacity = 2
  }

   storage_profile_image_reference {
     publisher = "Canonical"
     offer     = "UbuntuServer"
     sku       = "18.04-LTS"
     version   = "latest"
   }

   storage_profile_os_disk {
     name              = ""
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }

   os_profile {
  
  computer_name_prefix  = "appvm"
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

 output "dbvm" {
  value = azurerm_virtual_machine.dbvm
  sensitive = true
}

output "appvmss" {
  value = azurerm_virtual_machine_scale_set.appvmss
  sensitive = true
}
