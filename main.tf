module "describe_regions_for_ec2" {
  source     = "./iam_role"
  name       = "describe_regions_for_ec2"
  identifier = "ec2.amazonaws.com"
  policy     = data.aws_iam_policy_document.allow_describe_regions.json
}

module "example_sg" {
  source      = "./security-group"
  name        = "module-sg"
  vpc_id      = aws_vpc.example.id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}
