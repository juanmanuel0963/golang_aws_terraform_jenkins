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

variable "random_pet"{
  type    = string
}
/*
variable "eks_oidc_provider"{
  type    = string
}

variable "eks_oidc_provider_arn"{
  type    = string
}
*/
locals {
  iam_policy_name           = "eks_load_balancer_controller_policy_${var.random_pet}"
  iam_role_name             = "eks_load_balancer_cntroller_role_${var.random_pet}"
  iam_policy_attachment     = "eks_load_balancer_controller_policy_attach_${var.random_pet}"
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
resource "aws_iam_policy" "load_balancer_controller" {
  //name        = "AmazonEKSLoadBalancerControllerPolicyTF"
  name        = local.iam_policy_name
  path        = "/"
  description = "Policy for load balancer controller on EKS"
  policy = file("./microservices_kubernetes/iam/terraform/iam_policy.json")
}
*/
/*
resource "aws_iam_role" "load_balancer_controller" {
  //name = "AmazonEKSLoadBalancerControllerRoleTF"
  name        = local.iam_role_name
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""

        Principal = {
          Federated = "${var.eks_oidc_provider_arn}"
        }
        "Condition"= {
          "StringEquals"= {
                    "${var.eks_oidc_provider}:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      }
    ]
  })

}
*/
/*
resource "aws_iam_policy_attachment" "load_balancer_controller" {
  //name       = "AmazonEKSLoadBalancerControllerRoleTF"
  name        = local.iam_policy_attachment
  roles      = [aws_iam_role.load_balancer_controller.name]
  policy_arn = aws_iam_policy.load_balancer_controller.arn
}
*/
##################################################################################
# OUTPUT
##################################################################################
/*
output "aws_iam_policy_load_balancer_controller" {
  description = "iam policy load balancer controller"
  value = aws_iam_policy.load_balancer_controller.name
}

output "aws_iam_role_load_balancer_controller" {
  description = "iam role load balancer controller"
  value = aws_iam_role.load_balancer_controller
}

output "aws_iam_role_load_balancer_controller_arn" {
  description = "iam role load balancer controller iam role arn"
  value = aws_iam_role.load_balancer_controller.arn
}

output "aws_iam_policy_attachment_load_balancer_controller" {
  description = "iam policy attachment load balancer controller"
  value = aws_iam_policy_attachment.load_balancer_controller
}
*/