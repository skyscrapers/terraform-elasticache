locals {
  cw_alarm_custom_period = 3600 * var.custom_snapshot_rate
  cw_alarm_daily_period  = 3600 * 24
}


resource "aws_cloudwatch_metric_alarm" "lambda_redis_snapshot_copy_errors" {
  count               = var.enable ? 1 : 0
  alarm_name          = "redis_snapshot_copy_lambda_${var.environment}_errors"
  alarm_description   = "The errors on redis_snapshot_copy are higher than 1"
  namespace           = "AWS/Lambda"
  metric_name         = "Errors"
  statistic           = "Sum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 1
  evaluation_periods  = 1
  period              = local.cw_alarm_custom_period

  alarm_actions = [var.sns_topic_arn]
  ok_actions    = [var.sns_topic_arn]

  dimensions = {
    FunctionName = aws_lambda_function.redis_copy_snapshot[0].function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_redis_snapshot_create_errors" {
  count               = var.enable ? 1 : 0
  alarm_name          = "redis_snapshot_create_invocation_${var.environment}_errors"
  alarm_description   = "The errors on redis_snapshot_create are higher than 1"
  namespace           = "AWS/Lambda"
  metric_name         = "Errors"
  statistic           = "Sum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 1
  evaluation_periods  = 1
  period              = local.cw_alarm_custom_period
  alarm_actions       = [var.sns_topic_arn]
  ok_actions          = [var.sns_topic_arn]

  dimensions = {
    FunctionName = aws_lambda_function.redis_create_snapshot[0].function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_redis_snapshot_cleanup_errors" {
  count               = var.enable ? 1 : 0
  alarm_name          = "redis_snapshot_cleanup_lambda_${var.environment}_errors"
  alarm_description   = "The errors on redis_snapshot_cleanup are higher than 1"
  namespace           = "AWS/Lambda"
  metric_name         = "Errors"
  statistic           = "Sum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 1
  evaluation_periods  = 1
  period              = local.cw_alarm_daily_period

  alarm_actions = [var.sns_topic_arn]
  ok_actions    = [var.sns_topic_arn]

  dimensions = {
    FunctionName = aws_lambda_function.redis_remove_snapshot[0].function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "invoke_redis_snapshot_lambda" {
  count               = var.enable ? 1 : 0
  alarm_name          = "redis-snapshot-invocation-${var.environment}-failed-invocations"
  alarm_description   = "Failed invocations for redis-snapshot-lambda"
  namespace           = "AWS/Events"
  metric_name         = "FailedInvocations"
  statistic           = "Sum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 1
  evaluation_periods  = 1
  period              = local.cw_alarm_custom_period

  alarm_actions = [var.sns_topic_arn]
  ok_actions    = [var.sns_topic_arn]

  dimensions = {
    RuleName = "invoke-redis-snapshot-lambda-${var.environment}"
  }
}

resource "aws_cloudwatch_metric_alarm" "invoke_redis_cleanup_lambda" {
  count               = var.enable ? 1 : 0
  alarm_name          = "redis-cleanup-invocations-${var.environment}-failed-invocations"
  alarm_description   = "Failed invocations for redis-cleanup-lambda"
  namespace           = "AWS/Events"
  metric_name         = "FailedInvocations"
  statistic           = "Sum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 1
  evaluation_periods  = 1
  period              = local.cw_alarm_daily_period

  alarm_actions = [var.sns_topic_arn]
  ok_actions    = [var.sns_topic_arn]

  dimensions = {
    RuleName = "invoke-redis-cleanup-lambda-${var.environment}"
  }
}

