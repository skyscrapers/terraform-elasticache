# terraform-elasticache
Terraform modules to set up redis and memcache(TODO).

## redis
This creates a redis cluster with some default values and creates a security group for the cluster that allows a specific security group to access the redis cluster

### Available variables:
 * [`name`]: String(required): The name of the redis cluster
 * [`environment`]: String(required): How do you want to call your environment, this is helpful if you have more than 1 VPC.
 * [`project`]: String(required): The project this redis cluster belongs to
 * [`node_type`]: String(required): The instance size of the redis cluster
 * [`num_cache_nodes`]: String(required): The number of cache nodes
 * [`subnets`]: String(required): The subnets where the redis cluster is deployed
 * [`allowed_sgs`]: List(required): The security groups that can access the redis cluster
 * [`vpc_id`]: String(required): The vpc where we will put the redis cluster
 * [`parameter_group_name`]: String: The parameter group name default to default.redis3.2
 * [`engine_version`]: String: The redis engine version. default to 3.2.4
 * [`port`]: String: The redis port default to 6379
 * [`automatic_failover_enabled`]: Boolean: Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. Defaults to false
 * [`availability_zones`]: String: the list of AZs where you want your cluster to be deployed in (The number of azs must be <= num_cache_nodes)
 * [`snapshot_window`]: String: The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum maintenance window is a 60 minute period. Example: 05:00-09:00
 * [`snapshot_retention_limit`]: String: The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot_retention_limit is not supported on cache.t1.micro or cache.t2.* cache nodes
 * [`snapshot_arns`]: List(Optional): A single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3. Example: arn:aws:s3:::my_bucket/snapshot1.rdb
 * [`at_rest_encryption_enabled`]: Bool(Optional, true) Whether to enable encryption at rest
 * [`transit_encryption_enabled`]: Bool(Optional, true) Whether to enable encryption in transit
 * [`auth_token`]: String(Optional) The password used to access a password protected server. Can be specified only if `transit_encryption_enabled = true`
 * [`notification_topic_arn`]: String(Optional) (Optional) ARN of an SNS topic to send ElastiCache notifications

### Output
* [`redis_sg`]: String: The security group ID of the redis cluster.
* [`primary_endpoint_address`]: String: The address of the replication group configuration endpoint when cluster mode is enabled.

### Example

```teraform
module "redis" {
  source        = "github.com/skyscrapers/terraform-elasticache//redis"
  name = "redis"
  project     = "${var.project}"
  environment = "${var.environment}"
  node_type = "cache.t2.micro"
  num_cache_nodes = "1"
  subnets = "${module.vpc.private_db_subnets}"
  allowed_sgs = ["${module.app_static.sg_id}"]
  vpc_id = "${module.vpc.vpc_id}"
}
```
