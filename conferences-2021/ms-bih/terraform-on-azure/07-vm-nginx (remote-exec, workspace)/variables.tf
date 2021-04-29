########################################
# LOCALS
########################################

locals {
  env_name = lower(terraform.workspace)
}

####################
# VARIABLES
####################

variable "vm_name" {
  type    = string
  default = "nginx"
}

variable "vm_size" {
  type = map(string)
  default = {
    dev  = "Standard_B1s"
    qa   = "Standard_B2s"
    prod = "Standard_B4ms"
  }
}

variable "source_code" {
  type = map(string)
  default = {
    dev  = "learn-azure-v2-dev"
    qa   = "learn-azure-v2-qa"
    prod = "learn-azure-v2-prod"
  }
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