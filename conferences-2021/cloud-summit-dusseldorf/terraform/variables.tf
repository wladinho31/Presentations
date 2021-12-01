####################
# VARIABLES
####################

variable "vm_name" {
  type    = string
  default = "myDemoLinuxVm"
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
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