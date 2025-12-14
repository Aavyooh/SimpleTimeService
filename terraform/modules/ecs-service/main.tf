resource "aws_ecs_service" "this" {
  name            = var.ecs_service_name
  cluster         = var.ecs_cluster_arn
  task_definition = var.task_definition_arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = var.ecs_security_groups
    assign_public_ip = false
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  depends_on = [
    var.listener_dependency
  ]

  lifecycle {
    ignore_changes = [task_definition]
  }

  tags = {
    Name = var.ecs_service_name
  }
}
