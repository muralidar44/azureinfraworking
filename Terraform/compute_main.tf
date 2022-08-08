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

resource "azurerm_availability_set" "mediaavsetdb" {
   name                         = var.mediaavsetname
   location                     = azurerm_resource_group.mediarg.location
   resource_group_name          = azurerm_resource_group.mediarg.name
   platform_fault_domain_count  = 2
   platform_update_domain_count = 2
   managed                      = true
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

   storage_image_reference {
     publisher = var.webvm_image_publisher
     offer     = var.webvm_image_offer
     sku       = var.rhel_8_2_sku
     version   = "latest"
   }

   storage_os_disk {
     name              = "myosdisk${count.index}"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = "Standard_LRS"
   }

   
   os_profile {
  count                 = 2
  computer_name  = "webvmcomputer${count.index}"
  admin_username = var.linux_admin_username
  admin_password = random_password.linux-vm-password.result
   }

   os_profile_linux_config {
     disable_password_authentication = false
   }

   tags = {
     environment = "staging"
   }
 }