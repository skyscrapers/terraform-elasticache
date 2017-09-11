variable "name" {
  description = "The name of the redis cluster"
}

variable "environment" {
  description = "How do you want to call your environment"
}

variable "project" {
  description = "The project this redis cluster belongs to"
}

variable "node_type" {
  description = "The instance size of the redis cluster"
}

variable "num_cache_nodes" {
  description = "The number of cache nodes"
}

variable "subnets" {
  description = "The subnets where the redis cluster is deployed"
  type        = "list"
}

variable "allowed_sgs" {
  description = "The security group that can access the redis cluster"
  type        = "list"
}

variable "vpc_id" {
  description = "The vpc where we will put the redis cluster"
}

variable "parameter_group_name" {
  description = "The parameter group name"
  default     = "default.redis3.2"
}

variable "engine_version" {
  description = "The redis engine version"
  default     = "3.2.4"
}

variable "port" {
  description = "The redis port"
  default     = "6379"
}

variable "automatic_failover_enabled" {
  default = false
}

variable "availability_zones" {
  description = "the list of AZs where you want your cluster to be deployed in"
  type        = "list"
}
