provider "random" {}

resource "random_string" "password" {
  length  = 32
  special = false
}

resource "aws_db_instance" "example" {
  engine              = "mysql"
  instance_class      = "db.t3.small"
  allocated_storage   = 20
  skip_final_snapshot = true
  username            = "admin"
  password            = random_string.password.result
}