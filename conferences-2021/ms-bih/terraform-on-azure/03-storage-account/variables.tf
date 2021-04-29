####################
# VARIABLES
####################

variable "sa_name" {
  type    = string
  default = "projectterraformbih"
}

variable "container_name" {
  type    = string
  default = "bootdiagnostics"
}

variable "tags" {
  type = map(string)
  default = {
    env = "project-terraform-bih"
  }
}