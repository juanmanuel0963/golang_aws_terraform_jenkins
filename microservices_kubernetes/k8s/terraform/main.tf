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

variable "aws_iam_role_load_balancer_controller_arn"{
  type    = string
}

locals {
  k8s_load_balancer_controller_name    = "k8s-load-balancer-controller-${var.random_pet}" 
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

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

#############################################################################
# RESOURCES
#############################################################################  
/*
resource "kubernetes_deployment_v1" "example" {
  metadata {
    name = "terraform-example"
    labels = {
      app = "MyExampleApp"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "MyExampleApp"
      }
    }

    template {
      metadata {
        labels = {
          app = "MyExampleApp"
        }
      }

      spec {
        container {
          image = "nginx:1.23.1"
          name  = "example"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}
*/
/*
resource "kubernetes_ingress_v1" "example_ingress" {
  metadata {
    name = "example-ingress"
    annotations = {
      "alb.ingress.kubernetes.io/scheme" =  "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }    
  }

spec {
    ingress_class_name = "alb"

    rule {
      http {
        path {
          backend {
            service {
              name = kubernetes_service.example_np.metadata.0.name
              port {
                number = kubernetes_service.example_np.spec.0.port.0.port
              }
            }
          }

          path = "/*"
        }

     
      }
    }


  }
}
*/
/*
resource "kubernetes_service_account_v1" "k8s_load_balancer_controller" {
  metadata {
    name      = local.k8s_load_balancer_controller_name
    //name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      //"eks.amazonaws.com/role-arn" = data.terraform_remote_state.eks.outputs.load_balancer_controller_iam_role_arn
      "eks.amazonaws.com/role-arn" = var.aws_iam_role_load_balancer_controller_arn 
    }
  }
}
*/
##################################################################################
# OUTPUT
##################################################################################
/*
output "aws_k8s_load_balancer_controller_id" {
  description = "k8s load balancer controller id"
  value = kubernetes_service_account_v1.k8s_load_balancer_controller.id
}
*/
/*
output "aws_eks_the_eks_oidc_provider_arn" {
  description = "EKS OIDC provider ARN"
  value = module.eks.oidc_provider_arn
}
*/
