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

variable "replica_region" {
  type = "string"
}

variable "source_region" {
  type = "string"
}
