resource "aws_lb_target_group" "example" {
  name                 = "example"
  target_type          = "ip"
  vpc_id               = aws_vpc.example.id
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 300

  health_check {
    path = "/"
    # 正常判定までの実行回数
    healthy_threshold = 5
    # 異常判定を行うまでの実行回数
    unhealthy_threshold = 2
    # ヘルスチェックのタイムアウト時間
    timeout = 5
    # ヘルスチェックの実行間隔
    interval = 30
    matcher  = 200
    port     = "traffic-port"
    protocol = "HTTP"
  }

  depends_on = [aws_lb.example]
}
