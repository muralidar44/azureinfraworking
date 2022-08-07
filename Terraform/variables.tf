variable "webvm_image_publisher" {
  type        = string
  description = "Virtual machine source image publisher"
  default     = "RedHat"
}
variable "webvm_image_offer" {
  type        = string
  description = "Virtual machine source image offer"
  default     = "RHEL"
}
variable "rhel_8_2_sku" {
  type        = string
  description = "SKU for RHEL 8.2"
  default     = "8.2"
}
variable "mediaavsetname" {
  type        = string
  description = "availability set name"  
}
variable "vmsku" {
  type        = string
  description = "Virtual machine sku"
  default     = "Standard_D4s_v5"
}
variable "linux_admin_username" {
  type        = string
  description = "linux username"  
}