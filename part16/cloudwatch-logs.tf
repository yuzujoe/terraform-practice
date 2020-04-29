data "aws_iam_policy_document" "cloudwatch_logs" {
  statement {
    effect    = "Allow"
    actions   = ["firehose:*"]
    resources = ["arn:aws:firehose:ap-northeast-1:*:*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = ["arn:aws:iam:*:role/cloudwatch-logs"]
  }
}

resource "aws_cloudwatch_log_subscription_filter" "example" {
  destination_arn = aws_kinesis_firehose_delivery_stream.example.arn
  filter_pattern  = "[]"
  log_group_name  = aws_cloudwatch_log_group.for_ecs_scheduled_task.name
  name            = "example"
  role_arn        = module.cloudwatch_logs_role.iam_role_arn
}
