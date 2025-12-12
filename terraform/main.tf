module "vpc" {
  source   = "./modules/vpc"
  env      = var.environment
  vpc_cidr = var.vpc_cidr
}
