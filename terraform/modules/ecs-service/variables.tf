variable "ecs_service_name" {
  type = string
}

variable "ecs_cluster_arn" {
  type = string
}

variable "task_definition_arn" {
  type = string
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "private_subnets" {
  type = list(string)
}

variable "ecs_security_groups" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}

variable "container_name" {
  type = string
}

variable "container_port" {
  type = number
}

variable "listener_dependency" {
  description = "ALB listener dependency to enforce creation order"
}
