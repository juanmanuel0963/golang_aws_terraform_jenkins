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

variable "vpc_private_subnets"{
  type    = list(string)
}

variable "vpc_id" {
  type    = string
}

variable "random_pet"{
  type    = string
}

locals {
  eks_name    = "cluster_eks_${var.random_pet}" 
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

#############################################################################
# RESOURCES
#############################################################################  
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.14"

  //cluster_name    = "cluster-eks-tf"
  cluster_name    = local.eks_name
  cluster_version = "1.26"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = var.vpc_id
  subnet_ids = var.vpc_private_subnets

  eks_managed_node_groups = {
      eks_group1 = {
        min_size     = 1
        max_size     = 3
        desired_size = 1
        instance_types = ["t2.micro"]
      }
    }


  fargate_profiles = {
    fg-developers = {
      name = "fg-developers"
      selectors = [
        {
          namespace = "fg-developers"
        }
      ]
    }
  }

  tags = {
        Terraform = "true"
        Environment = "dev"
  }

}
##################################################################################
# OUTPUT
##################################################################################

output "aws_eks_the_eks_oidc_provider" {
  description = "EKS OIDC provider"
  value = module.eks.oidc_provider
}

output "aws_eks_the_eks_oidc_provider_arn" {
  description = "EKS OIDC provider ARN"
  value = module.eks.oidc_provider_arn
}

