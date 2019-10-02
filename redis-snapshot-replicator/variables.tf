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
  type = string
}

variable "custom_snapshot_rate" {
  type        = number
  default     = 6
  description = "Number of hours to take custom RDS snapshots every each"
}

variable "sns_topic_arn" {
  type        = string
  description = "ARN of SNS topic to use for monitoring of the snapshot creation, copy, and cleanup process"
}


variable "redis_sns_topic_arn" {
  type        = string
  description = "ARN of SNS topic the ElastiCache cluster sends notification to"
}


variable "backup_retention_days" {
  type    = number
  default = 30
}
