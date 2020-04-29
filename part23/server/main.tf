locals {
  vpc_id = "vpc-05cdedef5fe146f67"
  subnet_id = "subnet-0ba34a2acaee2aec0"
}

resource "aws_instance" "server" {
  ami = "ami-0c3fd0f5d33134a76"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.server.id]
  subnet_id = local.subnet_id
}

resource "aws_security_group" "server" {
  vpc_id = local.vpc_id
}
