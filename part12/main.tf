resource "aws_ssm_parameter" "db_username" {
  name        = "/db/username"
  type        = "String"
  value       = "root"
  description = "データベースのユーザー名"
}

resource "aws_ssm_parameter" "db_row_password" {
  name        = "/db/raw_password"
  type        = "SecureString"
  value       = "VeryStrongPassword"
  description = "データベースのパスワード"
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/db/password"
  type        = "SecureString"
  value       = "uninitialized"
  description = "データベースのパスワード"

  lifecycle {
    ignore_changes = [value]
  }
}
