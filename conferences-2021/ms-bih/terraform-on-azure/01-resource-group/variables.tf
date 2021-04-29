####################
# VARIABLES
####################

variable "location" {
  type    = string
  default = "northeurope"
}

variable "rg_name" {
  type    = string
  default = "project-terraform-bih"
}

variable "tags" {
  type = map(string)
  default = {
    env = "project-terraform-bih"
  }
}