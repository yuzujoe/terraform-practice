resource "aws_cloudwatch_log_group" "for_ecs_scheduled_tasks" {
  name              = "/ecs-scheduled-tasks/example"
  retention_in_days = 180
}

resource "aws_ecs_task_definition" "example_batch" {
  container_definitions    = file("./batch_container_definitions.json")
  family                   = "example-batch"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
}

resource "aws_cloudwatch_event_rule" "example-batch" {
  name                = "example-batch"
  description         = "とても重要なバッチ処理です"
  schedule_expression = "cron(*/2****?*)"
}

resource "aws_cloudwatch_event_target" "example_batch" {
  arn       = aws_ecs_cluster.example.arn
  rule      = "${aws_cloudwatch_event_rule.example-batch.name}"
  role_arn  = module.ecs_event_role.iam_role_arn
  target_id = "example-batch"

  ecs_target {
    task_definition_arn = aws_ecs_task_definition.example_batch.arn
    launch_type         = "FARGATE"
    task_count          = 1
    platform_version    = "1.3.0"

    network_configuration {
      assign_public_ip = "false"
      subnets          = [aws_subnet.private_0.id]
    }
  }
}

module "ecs_event_role" {
  source     = "./iam_role"
  name       = "ecs-events"
  identigier = "events.amazonaws.com"
  policy     = data.aws_iam_policy.ecs_events_role_policy.policy
}

data "aws_iam_policy" "ecs_events_role_policy" {
  arn = "arn:aws:iam:aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}
