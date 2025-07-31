# terraform-elasticache

Terraform modules to set up redis and memcache.

> [!WARNING]
> This module is deprecated and no longer receives active updates. We recommend using [`terraform-aws-modules/elasticache/aws`](https://registry.terraform.io/modules/terraform-aws-modules/elasticache/aws/latest) instead.

## redis

This creates a redis cluster with some default values and creates a security group for the cluster that allows a specific security group to access the redis cluster

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.15 |
| <a name="requirement_aws"></a> [aws](#requirement_aws) | >= 5.0.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider_aws) | >= 5.0.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_replication_group.redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.elasticache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_security_group.sg_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.sg_app_to_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_sgs"></a> [allowed_sgs](#input_allowed_sgs) | The security group that can access the redis cluster | `list(string)` | n/a | yes |
| <a name="input_availability_zones"></a> [availability_zones](#input_availability_zones) | the list of AZs where you want your cluster to be deployed in | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input_environment) | How do you want to call your environment | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input_name) | The name of the redis cluster | `string` | n/a | yes |
| <a name="input_node_type"></a> [node_type](#input_node_type) | The instance size of the redis cluster | `string` | n/a | yes |
| <a name="input_num_cache_nodes"></a> [num_cache_nodes](#input_num_cache_nodes) | The number of cache nodes | `number` | n/a | yes |
| <a name="input_project"></a> [project](#input_project) | The project this redis cluster belongs to | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input_subnets) | The subnets where the redis cluster is deployed | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id) | The vpc where we will put the redis cluster | `string` | n/a | yes |
| <a name="input_apply_immediately"></a> [apply_immediately](#input_apply_immediately) | (Optional) Whether to apply changes immediately or during the next maintenance window | `bool` | `true` | no |
| <a name="input_at_rest_encryption_enabled"></a> [at_rest_encryption_enabled](#input_at_rest_encryption_enabled) | (Optional) Whether to enable encryption at rest | `bool` | `true` | no |
| <a name="input_auth_token"></a> [auth_token](#input_auth_token) | (Optional) The password used to access a password protected server. Can be specified only if `transit_encryption_enabled = true` | `string` | `null` | no |
| <a name="input_auth_token_update_strategy"></a> [auth_token_update_strategy](#input_auth_token_update_strategy) | (Optional) Strategy to use when updating the auth_token. Valid values are SET, ROTATE, and DELETE. Required if auth_token is set. | `string` | `"ROTATE"` | no |
| <a name="input_automatic_failover_enabled"></a> [automatic_failover_enabled](#input_automatic_failover_enabled) | n/a | `bool` | `false` | no |
| <a name="input_cloudwatch_logging_enabled"></a> [cloudwatch_logging_enabled](#input_cloudwatch_logging_enabled) | (Optional) Whether to enable cloudwatch logging | `bool` | `false` | no |
| <a name="input_cloudwatch_logging_retention_in_days"></a> [cloudwatch_logging_retention_in_days](#input_cloudwatch_logging_retention_in_days) | Retention period for the logs in CloudWatch. Default is 7d. | `number` | `7` | no |
| <a name="input_engine_version"></a> [engine_version](#input_engine_version) | The redis engine version | `string` | `"3.2.6"` | no |
| <a name="input_multi_az_enabled"></a> [multi_az_enabled](#input_multi_az_enabled) | n/a | `bool` | `false` | no |
| <a name="input_notification_topic_arn"></a> [notification_topic_arn](#input_notification_topic_arn) | (Optional) ARN of an SNS topic to send ElastiCache notifications | `string` | `null` | no |
| <a name="input_parameter_group_name"></a> [parameter_group_name](#input_parameter_group_name) | The parameter group name | `string` | `"default.redis3.2"` | no |
| <a name="input_port"></a> [port](#input_port) | The redis port | `number` | `6379` | no |
| <a name="input_snapshot_arns"></a> [snapshot_arns](#input_snapshot_arns) | (Optional) A single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3. Example: arn:aws:s3:::my_bucket/snapshot1.rdb | `list(string)` | `[]` | no |
| <a name="input_snapshot_retention_limit"></a> [snapshot_retention_limit](#input_snapshot_retention_limit) | The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot_retention_limit is not supported on cache.t1.micro or cache.t2.* cache nodes | `number` | `0` | no |
| <a name="input_snapshot_window"></a> [snapshot_window](#input_snapshot_window) | The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum maintenance window is a 60 minute period. Example: 05:00-09:00 | `string` | `"03:00-05:00"` | no |
| <a name="input_transit_encryption_enabled"></a> [transit_encryption_enabled](#input_transit_encryption_enabled) | (Optional) Whether to enable encryption in transit | `bool` | `true` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_configuration_endpoint_address"></a> [configuration_endpoint_address](#output_configuration_endpoint_address) | n/a |
| <a name="output_primary_endpoint_address"></a> [primary_endpoint_address](#output_primary_endpoint_address) | n/a |
| <a name="output_redis_sg"></a> [redis_sg](#output_redis_sg) | n/a |
