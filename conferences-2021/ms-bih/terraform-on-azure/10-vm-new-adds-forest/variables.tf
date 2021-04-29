####################
# VARIABLES
####################

variable "vm_name" {
  type    = string
  default = "dc01"
}

variable "vm_size" {
  type    = string
  default = "Standard_B4ms"
}

variable "username" {
  type    = string
  default = "vladimir"
}

variable "password" {}

variable "tags" {
  type = map(string)
  default = {
    env = "project-terraform"
  }
}