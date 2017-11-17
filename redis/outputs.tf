output "redis_sg" {
  value = "${aws_security_group.sg_redis.id}"
}

output "configuration_endpoint_address" {
  value = "${aws_elasticache_replication_group.redis.configuration_endpoint_address}"
}

output "primary_endpoint_address" {
  value = "${aws_elasticache_replication_group.redis.primary_endpoint_address}"
}
