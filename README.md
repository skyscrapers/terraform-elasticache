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

### Output
 * [`role_arn`]: String: The Amazon Resource Name (ARN) specifying the role.
 * [`role_unique_id`]: String: The stable and unique string identifying the role.
 * [`profile_id`]: String: The instance profile's ID.
 * [`profile_arn`]: String: The ARN assigned by AWS to the instance profile.
 * [`profile_name`]: String: The instance profile's name.
 * [`policy_id`]: String: The role policy ID.
 * [`policy_name`]: String:  The name of the policy.
 * [`policy_policy`]: String: The policy document attached to the role.
 * [`policy_role`]: String: The role to which this policy applies.

### Example
```

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
