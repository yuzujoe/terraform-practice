resource "aws_acm_certificate" "example" {
  domain_name = aws_route53_record.example.name
  # ドメイン名を追加したい際は[]に追加する。
  subject_alternative_names = []
  # DNSかeメールかで検証する
  validation_method = "DNS"

  lifecycle {
    # 新しい証明書を作成してから古い証明書を削除する
    create_before_destroy = true
  }
}

resource "aws_route53_record" "example_certificate" {
  name    = aws_acm_certificate.example.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.example.domain_validation_options[0].resource_record_type
  records = [aws_acm_certificate.example.domain_validation_options[0].resource_record_value]
  zone_id = data.aws_route53_zone.example.id
  ttl     = 60
}
# apply時にSSLの検証が完了するまで待ってくれるようにするリソース
resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.example.arn
  validation_record_fqdns = [aws_route53_record.example_certificate.fqdn]
}
