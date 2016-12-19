variable "name" {
}
variable "environment" {
}
variable "project" {
}
variable "node_type" {
}
variable "num_cache_nodes" {
}
variable "subnets" {
  type = "list"
}
variable "allowed_sg" {
}
variable "vpc_id" {
}
variable "parameter_group_name" {
  default = "default.redis3.2"
}
variable "engine_version" {
  default = "3.2.4"
}
variable "port" {
  default = "6379"
}
