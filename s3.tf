resource "aws_s3_bucket" "private" {
  # bucket名は全世界で一意にする必要がある
  bucket = "private-pragmatic-terraform"

  versioning {
    # trueになるとオブジェクトを変更・削除しても以前のバージョンへ復元できる
    enabled = true
  }
  # 暗号化を有効化できる
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
# block public accessを有効にすると予期しないオブジェクトの公開を抑止できる
resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.private.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "public" {
  bucket = "public-pragmatic-terraform"
  acl    = "public-read"

  cors_rule {
    allowed_origins = ["https://example.com"]
    allowed_methods = ["GET"]
    allowed_headers = ["*"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket" "alb_log" {
  bucket = "alb-log-pragmatic-terraform"

  lifecycle_rule {
    enabled = true
    # 指定した日数経過したファイルは削除する
    expiration {
      days = "180"
    }
  }
}

resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect    = "Allow"
    actions   = ["s3:Putobject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]

    principals {
      type        = "AWS"
      identigiers = ["273172227336"]
    }
  }
}

# resource "aws_s3_bucket" "force_destroy" {
#   bucket        = "force-descroy-pragmatic-terraform"
#   force_destroy = true
# }
