variable "rentention" {
  default = 30
}

variable "db_instances" {
  type    = list(string)
  default = []
}

variable "name" {
  type = string
}

variable "enable" {
  default = false
}

variable "environment" {
}

