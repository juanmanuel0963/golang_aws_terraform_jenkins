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

variable "instance_name" {
  type    = string
}

variable "instance_id" {
  type    = string
}

variable "instance_private_ip" {
  type    = string
}

variable "server_private_ip" {
  type    = string
}

variable "function_name" {
  type    = string
}

variable "random_pet"{
  type    = string
}

locals {
  availability_zone       = "${var.region}c"  
  rule_name               = "${var.instance_name}_${var.function_name}_rule_${var.random_pet}"
  iam_role_name           = "${var.instance_name}_${var.function_name}_iam_role_${var.random_pet}"
}

#############################################################################
# PROVIDERS
#############################################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.3.0"
    }
  }
}

provider "aws" {
  region = var.region
  //access_key = var.access_key
  //secret_key = var.secret_key
}

#############################################################################
# MODULES
#############################################################################  

#############################################################################
# RESOURCES
#############################################################################  

//----------IAM Rol creation----------

//Defines an IAM role that allows Lambda to access resources in your AWS account.
resource "aws_iam_role" "the_iam_role" {
  name = local.iam_role_name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
      },
    ]
  })

}

//----------Policy assignment to the IAM Rol----------

//Attaches a policy to the IAM role.
//AmazonEC2FullAccess Provides full access to Amazon EC2 via the AWS Management Console.
resource "aws_iam_role_policy_attachment" "the_execution_role" {
  role        = aws_iam_role.the_iam_role.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

#-----Cloudwatch Rule--------

resource "aws_cloudwatch_event_rule" "the_rule" {
  name                = "${local.rule_name}"
  description         = "${local.rule_name}"
  schedule_expression = "cron(* * * * ? *)" //every 1 minute
}

#-----Cloudwatch Target--------

resource "aws_cloudwatch_event_target" "the_target" {
  target_id = "${var.instance_name}_${var.function_name}_target"
  arn       = "arn:aws:ssm:${var.region}::document/AWS-RunShellScript"
  input     = "{\"commands\":[\"export server_address=${var.server_private_ip}\",\"export HOME=/home/ubuntu\",\"export GOPATH=$HOME/go\",\"export GOMODCACHE=$HOME/go/pkg/mod\",\"export GOCACHE=$HOME/.cache/go-build\",\"cd /home/ubuntu/\",\"cd golang_aws_terraform_jenkins\",\"cd microservices_grpc_ec2/usermgmt_op1_no_persistence/usermgmt_client\",\"sudo chmod 700 usermgmt_client\",\"sudo --preserve-env ./usermgmt_client\"]}"
  rule      = aws_cloudwatch_event_rule.the_rule.name
  role_arn  = aws_iam_role.the_iam_role.arn

  run_command_targets {
    key    = "InstanceIds"
    values = ["${var.instance_id}"]
  }
}

##################################################################################
# aws_cloudwatch_event_rule - OUTPUT
##################################################################################

output "aws_cloudwatch_event_rule_name" {
  description = "EventBridge rule name"
  value = aws_cloudwatch_event_rule.the_rule.name
}

