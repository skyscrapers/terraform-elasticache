variable "rentention" {
  default = 30
  type    = number
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
  type    = bool
}

variable "environment" {
  type    = string
}

