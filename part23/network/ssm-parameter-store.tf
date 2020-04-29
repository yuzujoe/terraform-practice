resource "aws_ssm_parameter" "vpc_id" {
  name  = "/staging/vpc/id"
  type  = "String"
  value = aws_vpc.staging.id
}

resource "aws_ssm_parameter" "subnet_id" {
  name  = "/staging/public/subnet/id"
  type  = "String"
  value = aws_subnet.public_staging.id
}
