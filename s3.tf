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

