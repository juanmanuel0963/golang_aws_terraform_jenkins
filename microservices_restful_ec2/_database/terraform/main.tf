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

variable "function_name" {
  type    = string
}

variable "random_pet"{
  type    = string
}

variable "db_username" {
  type    = string
}

variable "db_password" {
  type    = string
}

variable "db_instance_address" {
  type    = string
}

variable "db_instance_endpoint" {
  type    = string
}

variable "db_instance_db_name" {
  type    = string
}

variable "db_port" {
  type    = string
}

locals {
  availability_zone       = "${var.region}c"  
  db_conn                 = "host=${var.db_instance_address} user=${var.db_username} password=${var.db_password} dbname=${var.db_instance_db_name} port=${var.db_port} sslmode=disable"
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
# MODULES
#############################################################################  

#############################################################################
# RESOURCES
#############################################################################  

//----------IAM Rol creation----------

//Defines an IAM role that allows Lambda to access resources in your AWS account.
resource "aws_iam_role" "the_iam_role" {
  //name = "${var.instance_name}_${var.function_name}_iam_role"
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
  //name                = "${var.instance_name}_${var.function_name}_rule"
  //description         = "${var.instance_name}_${var.function_name}_rule"
  name                = "${local.rule_name}"
  description         = "${local.rule_name}"
  //schedule_expression = "cron(0 * * * ? *)" //every one hour
  schedule_expression = "cron(* * * * ? *)" //every 1 minute
  //schedule_expression = "rate(1 minute)"
}

#-----Cloudwatch Target--------

resource "aws_cloudwatch_event_target" "the_target" {
  target_id = "${var.instance_name}_${var.function_name}_target"
  arn       = "arn:aws:ssm:${var.region}::document/AWS-RunShellScript"
  //input     = "{\"commands\":[\"ls -a\"]}"
  input     = "{\"commands\":[\"cd /home/ubuntu/\",\"cd golang_aws_terraform_jenkins/microservices_restful_ec2/_database\",\"export db_conn='${local.db_conn}'\",\"sudo chmod 700 ./migrate/migrate\",\"sudo --preserve-env ./migrate/migrate\"]}"
  //\"sudo chmod -R a+rwx /home/ubuntu/\",
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

/*
//----------CloudWatch assignment event----------

//Defines a log group to store log messages from your Lambda function for 30 days. 
//By convention, Lambda stores logs in a group with the name /aws/lambda/<Function Name>.
resource "aws_cloudwatch_log_group" "the_log_group" {
  name = "/aws/events/${aws_cloudwatch_event_rule.the_rule.name}"
  retention_in_days = 30
}
*/
