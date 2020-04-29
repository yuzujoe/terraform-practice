module "kinesis_data_firehose_role" {
  source     = "./iam_role"
  name       = "kinesis-data-firehose"
  policy     = data.aws_iam_policy_document.kinesis_data_firehose.json
  identifier = "firehose.amazonaws.com"
}

module "cloudwatch_logs_role" {
  source     = "./iam_role"
  name       = "cloudwatch-logs"
  identifier = "logs.ap-northeast-1.amazonaws.com"
  policy     = data.aws_iam_policy_document.cloudwatch_logs.json
}
