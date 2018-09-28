resource "aws_iam_role" "replication-role" {
  name = "redis-replication-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "replication-policy" {
  name = "redis-replication-policy"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.bucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.destination.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "replication" {
  name       = "redis-replication-attachment"
  roles      = ["${aws_iam_role.replication-role.name}"]
  policy_arn = "${aws_iam_policy.replication-policy.arn}"
}

resource "aws_s3_bucket" "destination" {
  bucket   = "redis-snapshots-destination"
  region   = "eu-central-1"
  provider = "aws.eu-central-1"

  versioning {
    enabled = true
  }

}

resource "aws_s3_bucket" "bucket" {
  provider = "aws"
  bucket   = "redis-snapshots"
  acl      = "private"
  region   = "eu-west-1"

  versioning {
    enabled = true
  }

  replication_configuration {
    role = "${aws_iam_role.replication-role.arn}"

    rules {
      id     = "redis"
      prefix = "snapshot-"
      status = "Enabled"

      destination {
        bucket        = "${aws_s3_bucket.destination.arn}"
        storage_class = "STANDARD"
      }
    }
  }
}


resource "aws_iam_policy" "redis_lambda_create_snapshot" {
  name = "redis_lambda_create_snapshot"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "elasticache:CreateSnapshot"
    ],
    "Resource": "*"
  }]
}
EOF
}

resource "aws_iam_role" "iam_for_lambda_redis" {
  name = "default_lambda_for_redis"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_lambda_create_policy_to_role" {
  role       = "${aws_iam_role.iam_for_lambda_redis.name}"
  policy_arn = "${aws_iam_policy.redis_lambda_create_snapshot.arn}"
}


resource "aws_iam_policy" "redis_lambda_copy" {
  name = "redis_lambda_copy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "elasticache:CopySnapshot",
        "s3:ListAllMyBuckets",
        "s3:ListBucket",
        "s3:PutObjectTagging",
        "s3:DeleteObject",
        "s3:HeadBucket",
        "elasticache:Describe*"
    ],
    "Resource": "*"
  }]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_redis_lambda_copy_policy_to_role" {
  role       = "${aws_iam_role.iam_for_lambda_redis.name}"
  policy_arn = "${aws_iam_policy.redis_lambda_copy.arn}"
}
#Create zip file with all lambda code
data "archive_file" "create_zip" {
  type        = "zip"
  output_path = "${path.module}/shipper.zip"

  source_dir = "${path.module}/functions/"
}

locals {
  # Solution from this comment to open issue on non-relative paths  # https://github.com/hashicorp/terraform/issues/8204#issuecomment-332239294

  filename = "${substr(data.archive_file.create_zip.output_path, length(path.cwd) + 1, -1)}"

  // +1 for removing the "/"
}

#Creation of lambda function to create snapshots

resource "aws_lambda_function" "redis_create_snapshot" {
  function_name = "redis_create_snapshot"
  role          = "${aws_iam_role.iam_for_lambda_redis.arn}"
  handler       = "create_snapshot.lambda_handler"

  filename         = "${local.filename}"
  source_code_hash = "${base64sha256(file("${local.filename}"))}"

  runtime = "python2.7"
  timeout = "120"

  environment {
    variables = {
      DB_INSTANCES  = "${join(",",var.db_instances)}"
    }
  }
}

#Creation of lambda function to copy snapshots

resource "aws_lambda_function" "redis_copy_snapshot" {
  function_name = "redis_copy_snapshot"
  role          = "${aws_iam_role.iam_for_lambda_redis.arn}"
  handler       = "shipper.lambda_handler"

  filename         = "${local.filename}"
  source_code_hash = "${base64sha256(file("${local.filename}"))}"

  runtime = "python2.7"
  timeout = "120"

  environment {
    variables = {
      DB_INSTANCES  = "${join(",",var.db_instances)}"
      TARGET_BUCKET = "${aws_s3_bucket.bucket.id}"
    }
  }
}

#Creation of cronjobs 
#Job for triggering backups
resource "aws_cloudwatch_event_rule" "redis_every_6_hours" {
  name                = "redis_every_6_hours"
  description         = "Fires every 6 hours"
  schedule_expression = "rate(6 hours)"
}

resource "aws_cloudwatch_event_target" "activate_create_redis_backup_cron" {
  rule      = "${aws_cloudwatch_event_rule.redis_every_6_hours.name}"
  target_id = "redis-snapshot-creation"
  arn       = "${aws_lambda_function.redis_create_snapshot.arn}"
}

#Job for triggering copy job
resource "aws_cloudwatch_event_rule" "redis_every_7_hours" {
  name                = "redis_every_7_hours"
  description         = "Fires every 7 hours"
  schedule_expression = "rate(7 hours)"
}

resource "aws_cloudwatch_event_target" "activate_copy_redis_snapshot_cron" {
  rule      = "${aws_cloudwatch_event_rule.redis_every_7_hours.name}"
  target_id = "redis-snapshot-copy"
  arn       = "${aws_lambda_function.redis_copy_snapshot.arn}"
}