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
 * [`allowed_sg`]: String(required): The security group that can access the redis cluster
 * [`vpc_id`]: String(required): The vpc where we will put the redis cluster
 * [`parameter_group_name`]: String: The parameter group name default to default.redis3.2
 * [`engine_version`]: String: The redis engine version. default to 3.2.4
 * [`port`]: String: The redis port default to 6379

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
  module "packer_role" {
    source      = "github.com/skyscrapers/terraform-iam//kms_role"
    kms_key_arn = "${aws_kms_key.kms_key.arn}"
    environment = "staging"
  }
```
