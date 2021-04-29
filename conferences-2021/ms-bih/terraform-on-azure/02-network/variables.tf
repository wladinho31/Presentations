####################
# VARIABLES
####################

variable "vnet_name" {
  type    = string
  default = "project-terraform-vnet"
}

variable "address_space" {
  type    = list(string)
  default = ["10.123.0.0/16"]
}

variable "subnet_names" {
  type    = list(string)
  default = ["windows-subnet", "linux-subnet"]
}

variable "subnet_prefixes" {
  type    = list(string)
  default = ["10.123.1.0/24", "10.123.2.0/24"]
}

variable "tags" {
  type = map(string)
  default = {
    env = "project-terraform"
  }
}