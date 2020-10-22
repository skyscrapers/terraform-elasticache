output "memcache_sg" {
  value = aws_security_group.sg_memcache.id
}

output "cluster_address " {
  value = aws_elasticache_cluster.memcache.cluster_address
}

