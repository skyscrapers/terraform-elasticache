# terraform-elasticache
Terraform modules to set up redis and memcache.

## redis
This creates a redis cluster with some default values and creates a security group for the cluster that allows a specific security group to access the redis cluster

### Available variables:
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowed_sgs | The security group that can access the redis cluster | `list(string)` | n/a | yes |
| availability_zones | the list of AZs where you want your cluster to be deployed in | `list(string)` | n/a | yes |
| environment | How do you want to call your environment | `string` | n/a | yes |
| name | The name of the redis cluster | `string` | n/a | yes |
| node_type | The instance size of the redis cluster | `string` | n/a | yes |
| num_cache_nodes | The number of cache nodes | `number` | n/a | yes |
| project | The project this redis cluster belongs to | `string` | n/a | yes |
| subnets | The subnets where the redis cluster is deployed | `list(string)` | n/a | yes |
| vpc_id | The vpc where we will put the redis cluster | `string` | n/a | yes |
| at_rest_encryption_enabled | (Optional) Whether to enable encryption at rest | `bool` | `true` | no |
| auth_token | (Optional) The password used to access a password protected server. Can be specified only if `transit_encryption_enabled = true` | `string` | `null` | no |
| automatic_failover_enabled | n/a | `bool` | `false` | no |
| multi_az_enabled | n/a | `bool` | `false` | no |
| engine_version | The redis engine version | `string` | `"3.2.6"` | no |
| notification_topic_arn | (Optional) ARN of an SNS topic to send ElastiCache notifications | `string` | `null` | no |
| parameter_group_name | The parameter group name | `string` | `"default.redis3.2"` | no |
| port | The redis port | `number` | `6379` | no |
| snapshot_arns | (Optional) A single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3. Example: arn:aws:s3:::my_bucket/snapshot1.rdb | `list(string)` | `[]` | no |
| snapshot_retention_limit | The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot_retention_limit is not supported on cache.t1.micro or cache.t2.* cache nodes | `number` | `0` | no |
| snapshot_window | The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum maintenance window is a 60 minute period. Example: 05:00-09:00 | `string` | `"03:00-05:00"` | no |
| testing | (Optional) Just testing the tf doc creator | `list(string)` | `null` | no |
| transit_encryption_enabled | (Optional) Whether to enable encryption in transit | `bool` | `true` | no |


### Output
| Name | Description |
|------|-------------|
| primary_endpoint_address | The address of the replication group configuration endpoint when cluster mode is enabled |
| redis_sg | The security group ID of the redis cluster. |

### Example

```terraform
module "redis" {
  source          = "github.com/skyscrapers/terraform-elasticache//redis"
  name            = "redis"
  project         = var.project
  environment     = terraform.workspace
  node_type       = "cache.t3.small"
  num_cache_nodes = "1"
  subnets         = module.vpc.private_db_subnets
  allowed_sgs     = [module.app.sg_id]
  vpc_id          = module.vpc.vpc_id
}
```

## memcache


### Available variables 

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowed_sgs | The security group that can access the memcache cluster | `list(string)` | n/a | yes |
| environment | How do you want to call your environment | `string` | n/a | yes |
| name | The name of the memcache cluster | `string` | n/a | yes |
| node_type | The instance size of the memcache cluster | `string` | n/a | yes |
| num_cache_nodes | The number of cache nodes | `number` | n/a | yes |
| project | The project this memcache cluster belongs to | `string` | n/a | yes |
| subnets | The subnets where the memcache cluster is deployed | `list(string)` | n/a | yes |
| vpc_id | The vpc where we will put the memcache cluster | `string` | n/a | yes |
| engine_version | The memcache engine version | `string` | `"1.4.5"` | no |
| parameter_group_name | The parameter group name | `string` | `"default.memcached1.4"` | no |
| port | The memcache port | `number` | `11211` | no |

### Output
| Name | Description |
|------|-------------|
| memcache_endpoint | The DNS name of the memcache cluster  |
| memcache_sg | The security group ID of the memcache cluster. |

### Example

```terraform
module "memcache" {
  source          = "github.com/skyscrapers/terraform-elasticache//memcache"
  name            = "memcache"
  project         = var.project
  environment     = terraform.workspace
  node_type       = "cache.t3.small"
  num_cache_nodes = "1"
  subnets         = module.vpc.private_db_subnets
  vpc_id          = module.vpc.vpc_id
  allowed_sgs     = [module.app.sg_id]
}
```
