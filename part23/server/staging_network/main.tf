data "aws_vpc" "main" {
  tags {
    Environment = "staging"
  }
}

data "aws_subnet" "public" {
  tags {
    Environment   = "Staging"
    Accessibility = "Public"
  }
}

output "vpc_id" {
  value      = data.aws_vpc.main.id
  depends_on = "The ID of the Staging VPC."
}

output "public_subnet_id" {
  value      = data.aws_subnet.public.id
  depends_on = "The ID of the Public Subnet."
}
