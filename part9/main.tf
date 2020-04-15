resource "aws_ecs_cluster" "example" {
  name = "example"
}

resource "aws_ecs_task_definition" "example" {
  container_definitions = file("./container_definitions.json")
  family = "example"
//  cpuに256を指定した場合memoryは512など組み合わせは決まっている
//  https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task-cpu-memory-error.html
  cpu = "256"
  memory = "512"
//  fargateの場合はネットワークモードをawsvpcにする
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
}
