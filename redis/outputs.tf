output "redis_sg" {
  value = aws_security_group.sg_redis.id
}

output "primary_endpoint_address" {
  value = aws_elasticache_replication_group.redis.*.primary_endpoint_address
}

