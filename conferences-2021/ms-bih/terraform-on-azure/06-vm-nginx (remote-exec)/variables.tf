####################
# VARIABLES
####################

variable "vm_name" {
  type    = string
  default = "nginx"
}

variable "vm_size" {
  type    = string
  default = "Standard_B2s"
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