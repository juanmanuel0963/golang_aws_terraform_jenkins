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
/*
variable "vpc_private_subnets"{
  type    = list(string)
}
*/
/*
variable "vpc_id" {
  type    = string
}
*/
variable "random_pet"{
  type    = string
}

locals {
  eks_name    = "eks_cluster_${var.random_pet}" 
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
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
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
/*
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.15.1"

  cluster_name    = local.eks_name
  cluster_version = "1.26"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = var.vpc_id
  subnet_ids = var.vpc_private_subnets


  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }
  eks_managed_node_groups = {
      eks_group1 = {
        name         = "eks-group-1"
        min_size     = 1
        max_size     = 3
        desired_size = 1
        instance_types = ["t3.large"]
        capacity_type  = "SPOT"
        ami_id         = "ami-053b0d53c279acc90"
        key_name       = "env.key_pair"
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
}
*/
##################################################################################
# OUTPUT
##################################################################################

/*
output "aws_eks_the_eks_cluster_id" {
  description = "EKS OIDC provider ARN"
  value = module.eks.cluster_id
}

output "aws_eks_the_eks_oidc_provider" {
  description = "EKS OIDC provider"
  value = module.eks.oidc_provider
}

output "aws_eks_the_eks_oidc_provider_arn" {
  description = "EKS OIDC provider ARN"
  value = module.eks.oidc_provider_arn
}

output "kubeconfig_command" {
  description = "kueconfig_command"
  value = "rm $HOME/.kube/config ; aws eks update-kubeconfig --name eks_cluster_name"
}
*/

