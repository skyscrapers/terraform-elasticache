resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = "${var.project}-${var.environment}-${var.name}"
  replication_group_description = "Redis cluster for ${var.project}-${var.environment}-${var.name}"
  engine                        = "redis"
  engine_version                = var.engine_version
  port                          = var.port
  node_type                     = var.node_type
  number_cache_clusters         = var.num_cache_nodes
  parameter_group_name          = var.parameter_group_name
  security_group_ids            = [aws_security_group.sg_redis.id]
  subnet_group_name             = aws_elasticache_subnet_group.elasticache.id
  availability_zones            = var.availability_zones
  automatic_failover_enabled    = var.automatic_failover_enabled
  snapshot_window               = var.snapshot_window
  snapshot_retention_limit      = var.snapshot_retention_limit
  snapshot_arns                 = var.snapshot_arns
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  transit_encryption_enabled    = var.transit_encryption_enabled
  auth_token                    = var.auth_token
  notification_topic_arn        = var.notification_topic_arn 

  tags = {
    Name        = "${var.project}-${var.environment}-${var.name}"
    Environment = var.environment
    Project     = var.name
  }
}

resource "aws_elasticache_subnet_group" "elasticache" {
  name        = "${var.project}-${var.environment}-redis"
  description = "Our main group of subnets"
  subnet_ids  = var.subnets
}

