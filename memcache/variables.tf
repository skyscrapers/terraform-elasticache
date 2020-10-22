variable "name" {
  description = "The name of the memcache cluster"
  type        = string
}

variable "environment" {
  description = "How do you want to call your environment"
  type        = string
}

variable "project" {
  description = "The project this memcache cluster belongs to"
  type        = string
}

variable "node_type" {
  description = "The instance size of the memcache cluster"
  type        = string
}

variable "num_cache_nodes" {
  description = "The number of cache nodes"
  type        = number
}

variable "multi_az" {
  description = "(Optional) Whether to enable multiple availability zones. Applicable only when number of cache nodes is greater than 1"
  default     = false
  type        = bool
}

variable "subnets" {
  description = "The subnets where the memcache cluster is deployed"
  type        = list(string)
}

variable "allowed_sgs" {
  description = "The security group that can access the memcache cluster"
  type        = list(string)
}

variable "vpc_id" {
  description = "The vpc where we will put the memcache cluster"
  type        = string
}

variable "parameter_group_name" {
  description = "The parameter group name"
  default     = "default.memcached1.4"
  type        = string
}

variable "engine_version" {
  description = "The memcache engine version"
  default     = "1.4.5"
  type        = string
}

variable "port" {
  description = "The memcache port"
  default     = 11211
  type        = number
}





