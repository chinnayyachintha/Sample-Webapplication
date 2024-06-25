provider "aws" {
  region = "us-east-1"
}

resource "aws_ecs_cluster" "web_app_cluster" {
  name = "web-app-cluster"
}

resource "aws_ecs_task_definition" "web_app_task" {
  family                = "web-app-task"
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = "256"
  memory                = "512"

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = "${docker_image.backend.latest}"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    },
    {
      name      = "frontend"
      image     = "${docker_image.frontend.latest}"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "web_app_service" {
  name            = "web-app-service"
  cluster         = aws_ecs_cluster.web_app_cluster.id
  task_definition = aws_ecs_task_definition.web_app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.main.id]
    security_groups = [aws_security_group.main.id]
  }
}
