#README

## First steps before using the module

In order to use this module, the Elasticache accountid must me added to the root s3 bucket. (the source bucket from where the replication starts)
This way, the copy_snapshot command of Elasticache can do it's job.

### Needed steps

- Open the S3 console and go to newly created bucket (the source bucket from where the replication starts)
- Choose Permissions.
- Choose Access Control List.
- Under Access for other AWS accounts, choose + Add account.
- For Europe add this account id : ` 540804c33a284a299d2547575ce1010f2312ef3da9b3a053c8bc45bf233e4353 `

   Set the permissions on the bucket by choosing Yes for:
   List objects
   Write objects
   Read bucket permissions
   Choose Save.

### More info on the other account-id's

https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/backups-exporting.html#backups-exporting-grant-access

# Usage 

``` 
provider "aws" {
  alias  = "replica"
  region = "eu-central-1"
}

module "redis-snapshot-replicator" {
  source = ""
  db_instances = ["db_name", "db_name"]
  name = "prefix"
  source_region = "eu-west-1"
  replica_region = "eu-central-1"
   providers = {
    aws = "aws"
    aws.replica = "aws.replica"
  }
}
```