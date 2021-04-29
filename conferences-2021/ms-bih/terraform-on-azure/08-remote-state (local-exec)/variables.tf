####################
# VARIABLES
####################

variable "sa_name" {
  type    = string
  default = "terraformremotestate"
}

variable "container_name" {
  type    = string
  default = "remote-state"
}

variable "tags" {
  type = map(string)
  default = {
    env     = "project-terraform"
    project = "remote-state"
  }
}