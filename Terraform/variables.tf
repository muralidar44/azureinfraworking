variable "webvm_image_publisher" {
  type        = string
  description = "Virtual machine source image publisher"
}
variable "webvm_image_offer" {
  type        = string
  description = "Virtual machine source image offer"
}
variable "rhel_8_2_sku" {
  type        = string
  description = "SKU for RHEL 8.2"
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
variable "mediavnetcidr" {
type = string
description = "This is the mediawiki vnet cidr"
}

variable "mediavnet" {
type = string
description = "This is the mediawiki vnet"
}

variable "mediaappsubnet" {
type = string
description = "This is the mediawiki mediaappvmsubnet"
}

variable "mediaappsubnetcidr" {
type = string
description = "This is the mediawiki appvm subnet cidr"
}

variable "mediadbsubnet" {
type = string
description = "This is the mediawiki dbvm subnet "
}

variable "mediadbsubnetcidr" {
type = string
description = "This is the mediawiki db vm cidr"
}

variable "lbpublicipname" {
type = string
description = "This is the Load balancer public Ip Name"
}

variable "mediaapplbname" {
type = string
description = "This is the Load balancer Name"
}

variable "lbappbpname" {
type = string
description = "This is the Load balancer backend pool name"
}