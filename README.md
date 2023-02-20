# terraform-elasticache
Terraform modules to set up redis and memcache.

## redis
This creates a redis cluster with some default values and creates a security group for the cluster that allows a specific security group to access the redis cluster

### Available variables:
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_sgs"></a> [allowed\_sgs](#input\_allowed\_sgs) | The security group that can access the redis cluster | `list(string)` | n/a | yes |
| <a name="input_at_rest_encryption_enabled"></a> [at\_rest\_encryption\_enabled](#input\_at\_rest\_encryption\_enabled) | (Optional) Whether to enable encryption at rest | `bool` | `true` | no |
| <a name="input_auth_token"></a> [auth\_token](#input\_auth\_token) | (Optional) The password used to access a password protected server. Can be specified only if `transit_encryption_enabled = true` | `string` | `null` | no |
| <a name="input_automatic_failover_enabled"></a> [automatic\_failover\_enabled](#input\_automatic\_failover\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | the list of AZs where you want your cluster to be deployed in | `list(string)` | n/a | yes |
| <a name="input_cloudwatch_logging_enabled"></a> [cloudwatch\_logging\_enabled](#input\_cloudwatch\_logging\_enabled) | (Optional) Whether to enable cloudwatch logging | `bool` | `false` | no |
| <a name="input_cloudwatch_logging_retention_in_days"></a> [cloudwatch\_logging\_retention\_in\_days](#input\_cloudwatch\_logging\_retention\_in\_days) | Retention period for the logs in CloudWatch. Default is 7d. | `number` | `7` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The redis engine version | `string` | `"3.2.6"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | How do you want to call your environment | `string` | n/a | yes |
| <a name="input_multi_az_enabled"></a> [multi\_az\_enabled](#input\_multi\_az\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the redis cluster | `string` | n/a | yes |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | The instance size of the redis cluster | `string` | n/a | yes |
| <a name="input_notification_topic_arn"></a> [notification\_topic\_arn](#input\_notification\_topic\_arn) | (Optional) ARN of an SNS topic to send ElastiCache notifications | `string` | `null` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | The number of cache nodes | `number` | n/a | yes |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | The parameter group name | `string` | `"default.redis3.2"` | no |
| <a name="input_port"></a> [port](#input\_port) | The redis port | `number` | `6379` | no |
| <a name="input_project"></a> [project](#input\_project) | The project this redis cluster belongs to | `string` | n/a | yes |
| <a name="input_snapshot_arns"></a> [snapshot\_arns](#input\_snapshot\_arns) | (Optional) A single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3. Example: arn:aws:s3:::my\_bucket/snapshot1.rdb | `list(string)` | `[]` | no |
| <a name="input_snapshot_retention_limit"></a> [snapshot\_retention\_limit](#input\_snapshot\_retention\_limit) | The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot\_retention\_limit is not supported on cache.t1.micro or cache.t2.* cache nodes | `number` | `0` | no |
| <a name="input_snapshot_window"></a> [snapshot\_window](#input\_snapshot\_window) | The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum maintenance window is a 60 minute period. Example: 05:00-09:00 | `string` | `"03:00-05:00"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The subnets where the redis cluster is deployed | `list(string)` | n/a | yes |
| <a name="input_transit_encryption_enabled"></a> [transit\_encryption\_enabled](#input\_transit\_encryption\_enabled) | (Optional) Whether to enable encryption in transit | `bool` | `true` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The vpc where we will put the redis cluster | `string` | n/a | yes |


### Output
| Name | Description |
|------|-------------|
| <a name="output_configuration_endpoint_address"></a> [configuration\_endpoint\_address](#output\_configuration\_endpoint\_address) | n/a |
| <a name="output_primary_endpoint_address"></a> [primary\_endpoint\_address](#output\_primary\_endpoint\_address) | n/a |
| <a name="output_redis_sg"></a> [redis\_sg](#output\_redis\_sg) | n/a |

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
