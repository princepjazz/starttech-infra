
terraform {
  required_providers {
    aws = { source = "hashicorp/aws" version = "~> 5.0" }
  }
  backend "s3" {
    bucket = "starttech-terraform-state"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" { region = var.aws_region }

module "networking" {
  source   = "./modules/networking"
  project  = var.project
  vpc_cidr = var.vpc_cidr
}

module "storage" {
  source  = "./modules/storage"
  project = var.project
}

module "compute" {
  source            = "./modules/compute"
  project           = var.project
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  alb_sg_id         = module.networking.alb_sg_id
  ec2_sg_id         = module.networking.ec2_sg_id
  ecr_registry      = module.storage.ecr_registry_url
  image_tag         = var.image_tag
  mongo_uri         = var.mongo_uri
  redis_url         = module.cache.redis_endpoint
  ami_id            = var.ami_id
  instance_type     = var.instance_type
}

module "cache" {
  source            = "./modules/cache"
  project           = var.project
  vpc_id            = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  redis_sg_id       = module.networking.redis_sg_id
}

module "monitoring" {
  source               = "./modules/monitoring"
  project              = var.project
  asg_name             = module.compute.asg_name
  scale_up_policy_arn  = module.compute.scale_up_policy_arn
  scale_down_policy_arn = module.compute.scale_down_policy_arn
}
