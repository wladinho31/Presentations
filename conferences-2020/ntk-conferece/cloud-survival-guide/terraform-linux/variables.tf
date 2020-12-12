####################
# VARIABLES
####################

variable "vm_name" {
  type    = string
  default = ""
}

variable "vm_size" {
  type    = string
  default = ""
}

variable "username" {
  type    = string
  default = ""
}

variable "password" {}

variable "tags" {
  type = map(string)
  default = {
    environment = ""
  }
}