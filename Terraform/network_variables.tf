variable "mediavnetcidr" {
type = string
description = "This is the mediawiki vnet cidr"
}

variable "mediavnet" {
type = string
description = "This is the mediawiki vnet"
}

variable "mediawebsubnetcidr" {
type = string
description = "This is the mediawiki mediawebsubnet"
}

variable "mediawebsubnet" {
type = string
description = "This is the mediawiki mediawebsubnet"
}

variable "lbpublicipname" {
type = string
description = "This is the Load balancer public Ip Name"
}

variable "medialbname" {
type = string
description = "This is the Load balancer Name"
}

variable "lbbackendpoolname" {
type = string
description = "This is the Load balancer backend pool name"
}