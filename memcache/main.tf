resource "aws_elasticache_cluster" "memcache" {
  cluster_id           = "${var.project}-${var.environment}-${var.name}"
  engine               = "memcached"
  engine_version       = var.engine_version
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = var.parameter_group_name
  port                 = var.port
  security_group_ids   = [aws_security_group.sg_memcache.id]
  subnet_group_name    = aws_elasticache_subnet_group.elasticache.id
  az_mode              = var.num_cache_nodes > 1 ? "cross-az" : "single-az"

  tags = {
    Name        = "${var.project}-${var.environment}-${var.name}"
    Environment = var.environment
    Project     = var.name
  }
}

resource "aws_elasticache_subnet_group" "elasticache" {
  name        = "${var.project}-${var.environment}-memcache"
  subnet_ids  = var.subnets
}

