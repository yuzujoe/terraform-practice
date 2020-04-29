data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_elb_service_account" "current" {}

output "accoutn_id" {
  value = data.aws_caller_identity.current.account_id
}

output "region_name" {
  value = data.aws_region.current.name
}

output "alb_service_accont_id" {
  value = data.aws_elb_service_account.current.id
}
