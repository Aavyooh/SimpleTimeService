output "ecs_service_name" {
  value = aws_ecs_service.this.name
}

output "ecs_service_arn" {
  value = aws_ecs_service.this.arn
}
