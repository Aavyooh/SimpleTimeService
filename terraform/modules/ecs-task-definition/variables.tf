variable "family" {
  type = string
}

variable "cpu" {
  type    = string  
}

variable "memory" {
  type    = string
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "container_name" {
  type    = string  
}

variable "container_image" {
  type = string
}

variable "container_port" {
  type    = number
}

variable "log_group" {
  type    = string
}

variable "log_stream_prefix" {
  type    = string
}

variable "region" {
  type = string
}
