resource "aws_iam_role" "replication_role" {
  name = "${var.name}-replication-role-${var.environment}"

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

data "aws_iam_policy_document" "replication_policy" {
  statement {
    sid = "1"

    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}",
    ]
  }
  statement {
    sid = "2"

    actions = [
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
  statement {
    sid = "3"

    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
    ]

    resources = [
      "${aws_s3_bucket.destination.arn}/*",
    ]
  }
}

resource "aws_iam_policy" "replication_policy" {
  name = "${var.name}-replication-policy-${var.environment}"
  policy = "${data.aws_iam_policy_document.replication_policy.json}"
}

resource "aws_iam_role_policy_attachment" "replication_replication_attachement" {
  role       = "${aws_iam_role.replication_role.name}"
  policy_arn = "${aws_iam_policy.replication_policy.arn}"
} 

resource "aws_s3_bucket" "destination" {
  bucket   = "${var.name}-snapshots-destination-${var.environment}"
  provider = "aws.replica"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "bucket" {
  provider = "aws"
  bucket   = "${var.name}-snapshots-${var.environment}"

  versioning {
    enabled = true
  }

  replication_configuration {
    role = "${aws_iam_role.replication_role.arn}"

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
  name = "${var.name}-lambda-create-snapshot-${var.environment}"

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
  name = "default-lambda-for-${var.name}-${var.environment}"

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
  name = "${var.name}-lambda-copy-${var.environment}"

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

resource "aws_iam_policy" "redis_lambda_remove" {
  name = "${var.name}-lambda-remove-${var.environment}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
        "elasticache:DescribeSnapshots",
        "elasticache:DeleteSnapshot"
    ],
    "Resource": "*"
  }]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_redis_lambda_remove_policy_to_role" {
  role       = "${aws_iam_role.iam_for_lambda_redis.name}"
  policy_arn = "${aws_iam_policy.redis_lambda_remove.arn}"
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
  function_name = "${var.name}-create-snapshot-${var.environment}"
  role          = "${aws_iam_role.iam_for_lambda_redis.arn}"
  handler       = "create_snapshot.lambda_handler"

  filename         = "${local.filename}"
  source_code_hash = "${base64sha256(file("${local.filename}"))}"

  runtime = "python2.7"
  timeout = "120"

  environment {
    variables = {
      DB_INSTANCES = "${join(",",var.db_instances)}"
    }
  }
}

#Creation of lambda function to copy snapshots

resource "aws_lambda_function" "redis_copy_snapshot" {
  function_name = "${var.name}-copy-snapshot-${var.environment}"
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

#Creation of lambda function to remove source snapshots

resource "aws_lambda_function" "redis_remove_snapshot" {
  function_name = "${var.name}-remove-snapshot-${var.environment}"
  role          = "${aws_iam_role.iam_for_lambda_redis.arn}"
  handler       = "shipper.lambda_handler"

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

#Creation of cronjobs 
#Job for triggering backups
resource "aws_cloudwatch_event_rule" "redis_every_6_hours" {
  name                = "${var.name}-every-6_hours-${var.environment}"
  description         = "Fires every 6 hours"
  schedule_expression = "rate(6 hours)"
}

resource "aws_cloudwatch_event_target" "activate_create_redis_backup_cron" {
  rule      = "${aws_cloudwatch_event_rule.redis_every_6_hours.name}"
  target_id = "${var.name}-snapshot-creation-${var.environment}"
  arn       = "${aws_lambda_function.redis_create_snapshot.arn}"
}

#Job for triggering copy job
resource "aws_cloudwatch_event_rule" "redis_every_7_hours" {
  name                = "${var.name}-every-7-hours-${var.environment}"
  description         = "Fires every 7 hours"
  schedule_expression = "rate(7 hours)"
}

resource "aws_cloudwatch_event_target" "activate_copy_redis_snapshot_cron" {
  rule      = "${aws_cloudwatch_event_rule.redis_every_7_hours.name}"
  target_id = "${var.name}-snapshot-copy-${var.environment}"
  arn       = "${aws_lambda_function.redis_copy_snapshot.arn}"
}
resource "aws_cloudwatch_event_rule" "redis_every_8_hours" {
  name                = "${var.name}-every-8-hours-${var.environment}"
  description         = "Fires every 8 hours"
  schedule_expression = "rate(8 hours)"
}

resource "aws_cloudwatch_event_target" "activate_remove_redis_snapshot_cron" {
  rule      = "${aws_cloudwatch_event_rule.redis_every_8_hours.name}"
  target_id = "${var.name}-snapshot-remove-${var.environment}"
  arn       = "${aws_lambda_function.redis_remove_snapshot.arn}"
}

#Allow cloudwatch to execute lambda
resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda_copy" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.redis_copy_snapshot.arn}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.redis_every_7_hours.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda_create" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.redis_create_snapshot.arn}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.redis_every_6_hours.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda_remove" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.redis_remove_snapshot.arn}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.redis_every_8_hours.arn}"
}
