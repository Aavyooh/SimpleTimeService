################ VPC ################
module "vpc" {
  source   = "./modules/vpc"
  env      = var.environment
  vpc_cidr = var.vpc_cidr
}


################ Security Groups ################
module "security_groups" {
  source = "./modules/security-groups"

  vpc_id         = module.vpc.vpc_id
  alb_sg_name    = "alb-sg"
  ecs_sg_name    = "ecs-sg"
  container_port = 8080
}


################ ALB ################
module "alb" {
  source              = "./modules/alb"
  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  public_subnets      = module.vpc.public_subnets
  alb_security_groups = [module.security_groups.alb_sg_id]

  tg_name           = "stv-tg"
  tg_port           = 8080
  health_check_path = "/"
}


################ IAM (ECS Roles) ################
module "ecs_iam" {
  source = "./modules/iam-ecs"

  ecs_task_role_name      = "ecs-task-role"
  ecs_execution_role_name = "ecs-task-execution-role"
}


################ ECS Cluster ################
module "ecs_cluster" {
  source = "./modules/ecs-cluster"

  ecs_cluster_name = var.ecs_cluster_name
}



################ ECS Task Definition ################
module "ecs_task_definition" {
  source = "./modules/ecs-task-definition"

  family = "dev-ecs-sts-td"
  cpu    = "1024"
  memory = "2048"

  execution_role_arn = module.ecs_iam.ecs_task_execution_role_arn
  task_role_arn      = module.ecs_iam.ecs_task_role_arn

  container_name  = "sts-service"
  container_image = "nivedanchauhan/simpletimeservice:latest"
  container_port  = 8080

  log_group         = "/ecs/sts"
  log_stream_prefix = "sts-service"
  region            = var.region
}


################ ECS Service ################
module "ecs_service" {
  source = "./modules/ecs-service"

  ecs_service_name    = "dev-ecs-sts-sv"
  ecs_cluster_arn     = module.ecs_cluster.ecs_cluster_arn
  task_definition_arn = module.ecs_task_definition.task_definition_arn
  desired_count       = 1

  private_subnets     = module.vpc.private_subnets
  ecs_security_groups = [module.security_groups.ecs_sg_id]

  target_group_arn = module.alb.target_group_arn
  container_name   = "sts-service"
  container_port   = 8080

  listener_dependency = module.alb.listener_arn
}

