#############################################################################
# VARIABLES
#############################################################################

variable "region" {
  type    = string
}

variable "access_key" {
  type    = string
}

variable "secret_key" {
  type    = string
}

#############################################################################
# PROVIDERS
#############################################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.27"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.3.2"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }
}

provider "aws" {
  region = var.region
  //access_key = var.access_key
  //secret_key = var.secret_key
}

variable "random_pet"{
  type    = string
}

locals {
  vpc_name    = "vpc_${var.random_pet}" 
}

#############################################################################
# RESOURCES
#############################################################################  

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "~> 4.0"

    //name = "vpc-eks-tf"
    name = local.vpc_name
    cidr = "10.0.0.0/16"

    azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

    enable_nat_gateway = true
    enable_vpn_gateway = false

    tags = {
        Terraform = "true"
        Environment = "dev"
    }

    public_subnet_tags = {
        "kubernetes.io/role/elb" = "1"
        "kubernetes.io/cluster/vcc-eks-tf" = "shared"
    }

    private_subnet_tags = {
        "kubernetes.io/role/internal-elb" = "1"
        "kubernetes.io/cluster/vcc-eks-tf" = "shared"
    }
}

##################################################################################
# OUTPUT
##################################################################################

output "aws_vpc_the_custom_vpc_id" {
  description = "Id of the VPC"
  value = module.vpc.vpc_id
}

output "aws_vpc_the_custom_vpc_private_subnets" {
  description = "VPC Private subnets"
  value = module.vpc.private_subnets
}