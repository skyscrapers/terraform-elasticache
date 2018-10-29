variable "rentention" {
  default = 30
}

variable "db_instances" {
  type    = "list"
  default = []
}

variable "name" {
  type = "string"
}
