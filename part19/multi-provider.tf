//aliasを指定するとこちらのリージョンで作成される
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_vpc" "virginia" {
  cidr_block = "192.168.0.0/16"
  provider   = aws.virginia
}

resource "aws_vpc" "tokyo" {
  cidr_block = "192.168.0.0/16"
}

output "virginia_vpc" {
  value = aws_vpc.virginia.arn
}

output "tokyo_vpc" {
  value = aws_vpc.tokyo.arn
}
