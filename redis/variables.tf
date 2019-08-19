variable "name" {
  description = "The name of the redis cluster"
  type        = string
}

variable "environment" {
  description = "How do you want to call your environment"
  type        = string
}

variable "project" {
  description = "The project this redis cluster belongs to"
  type        = string
}

variable "node_type" {
  description = "The instance size of the redis cluster"
  type        = string
}

variable "num_cache_nodes" {
  description = "The number of cache nodes"
  type        = number
}

variable "subnets" {
  description = "The subnets where the redis cluster is deployed"
  type        = list(string)
}

variable "allowed_sgs" {
  description = "The security group that can access the redis cluster"
  type        = list(string)
}

variable "vpc_id" {
  description = "The vpc where we will put the redis cluster"
  type        = string
}

variable "parameter_group_name" {
  description = "The parameter group name"
  default     = "default.redis3.2"
  type        = string
}

variable "engine_version" {
  description = "The redis engine version"
  default     = "3.2.6"
  type        = string
}

variable "port" {
  description = "The redis port"
  default     = 6379
  type        = number
}

variable "automatic_failover_enabled" {
  default = false
  type    = bool
}

variable "availability_zones" {
  description = "the list of AZs where you want your cluster to be deployed in"
  type        = list(string)
}

variable "snapshot_window" {
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum maintenance window is a 60 minute period. Example: 05:00-09:00"
  default     = "03:00-05:00"
  type        = string
}

variable "snapshot_retention_limit" {
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot_retention_limit is not supported on cache.t1.micro or cache.t2.* cache nodes"
  default     = 0
  type        = number
}

variable "snapshot_arns" {
  description = "(Optional) A single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3. Example: arn:aws:s3:::my_bucket/snapshot1.rdb"
  type        = list(string)
  default     = []
}

variable "at_rest_encryption_enabled" {
  description = "(Optional) Whether to enable encryption at rest"
  default     = true
  type        = bool
}

variable "transit_encryption_enabled" {
  description = "(Optional) Whether to enable encryption in transit"
  default     = true
  type        = bool
}

variable "auth_token" {
  description = "(Optional) The password used to access a password protected server. Can be specified only if `transit_encryption_enabled = true`"
  default     = null
  type        = string
}

