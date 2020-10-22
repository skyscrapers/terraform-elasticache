output "memcache_sg" {
  value = aws_security_group.sg_memcache.id
}

output "memcache_endpoint" {
  value = aws_elasticache_cluster.memcache.cluster_address
}

