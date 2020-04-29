resource "aws_kinesis_firehose_delivery_stream" "example" {
  destination = "s3"
  name = "name"

  s3_configuration {
    bucket_arn = aws_s3_bucket.cloudwatch_logs.arn
    role_arn = module.kinesis_data_firehose_role.iam_role_arn
    prefix = "ecs-scheduled-tasks/example/"
  }
}
