####################
# VARIABLES
####################

variable "location" {
  type    = string
  default = "northeurope"
}

variable "rg_name" {
  type    = string
  default = "kulendayz-2021-rg"
}

variable "primary_sql_server_name" {
  type    = string
  default = "kd2021-sql01"
}

variable "primary_location" {
  type    = string
  default = "northeurope"
}

variable "secondary_sql_server_name" {
  type    = string
  default = "kd2021-sql02"
}

variable "secondary_location" {
  type    = string
  default = "westeurope"
}

variable "database_name" {
  type    = string
  default = "webappdemodatabase"
}

variable "failover_group_name" {
  type    = string
  default = "kd2021-mastersql"
}

variable "web_app_name" {
  type    = string
  default = "kd2021-terraform"
}

variable "tags" {
  type = map(string)
  default = {
    environment       = "kulendayz-2021"
    deployment-method = "terraform"
  }
}

variable "username" {
  type = string
  default = "vladimir"
}

variable "password" {
  type = string
  default = "Pa$$w0rd1234"
}