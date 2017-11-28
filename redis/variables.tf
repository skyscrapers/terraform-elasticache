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

variable "snapshot_window" {
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum maintenance window is a 60 minute period. Example: 05:00-09:00"
  default     = "03:00-05:00"
}

variable "snapshot_retention_limit" {
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot_retention_limit is not supported on cache.t1.micro or cache.t2.* cache nodes"
  default     = "0"
}

variable "snapshot_arns" {
  description = "(Optional) A single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3. Example: arn:aws:s3:::my_bucket/snapshot1.rdb"
  default     = ""
}
