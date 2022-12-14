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

variable "security_group_name"{
  type    = string
}

data "http" "local_home_ip_address" {
  url = "https://ifconfig.me/ip"
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

//----------Look up the default vpc----------

resource "aws_default_vpc" "default" { }

//----------Create The Security Group--------------
resource "aws_security_group" "the_security_group" {
  name        = var.security_group_name
  description = var.security_group_name
  vpc_id      = aws_default_vpc.default.id

  lifecycle {
    create_before_destroy = true
  }  
}

//-------Dynamic IPs---------------------------

resource "aws_security_group_rule" "ingress_from_local_home_to_postgresql" {
  security_group_id = aws_security_group.the_security_group.id
  description       = "ingress_from_home_to_postgresql"
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks      = ["${data.http.local_home_ip_address.response_body}/32"]
}

resource "aws_security_group_rule" "ingress_from_self_security_group" {
  security_group_id = aws_security_group.the_security_group.id
  description       = "ingress_from_self_${aws_security_group.the_security_group.id}"
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  self              = true  
}

resource "aws_security_group_rule" "ingress_from_local_home_to_ssh" {
  security_group_id = aws_security_group.the_security_group.id
  description       = "ingress_from_home_to_ssh"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks      = ["${data.http.local_home_ip_address.response_body}/32"]
}

resource "aws_security_group_rule" "ingress_from_local_home_to_3000" {
  security_group_id = aws_security_group.the_security_group.id
  description       = "ingress_from_home_to_3000"
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks      = ["${data.http.local_home_ip_address.response_body}/32"]
}

resource "aws_security_group_rule" "ingress_from_local_home_to_3001" {
  security_group_id = aws_security_group.the_security_group.id
  description       = "ingress_from_home_to_3001"
  type              = "ingress"
  from_port         = 3001
  to_port           = 3001
  protocol          = "tcp"
  cidr_blocks      = ["${data.http.local_home_ip_address.response_body}/32"]
}

//-------Static IPs for Prod/Jenkins ---------------------------
/*
resource "aws_security_group_rule" "ingress_from_local_home_static_to_postgresql" {
  security_group_id = aws_security_group.the_security_group.id
  description       = "ingress_from_home_static_to_postgresql"
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks      = ["186.155.15.156/32"]
}

resource "aws_security_group_rule" "ingress_from_local_home_static_to_ssh" {
  security_group_id = aws_security_group.the_security_group.id
  description       = "ingress_from_home_static_to_ssh"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks      = ["186.155.15.156/32"]
}

resource "aws_security_group_rule" "ingress_from_local_home_static_to_3000" {
  security_group_id = aws_security_group.the_security_group.id
  description       = "ingress_from_home_to_3000"
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks      = ["186.155.15.156/32"]
}

resource "aws_security_group_rule" "ingress_from_local_home_static_to_3001" {
  security_group_id = aws_security_group.the_security_group.id
  description       = "ingress_from_home_to_3001"
  type              = "ingress"
  from_port         = 3001
  to_port           = 3001
  protocol          = "tcp"
  cidr_blocks      = ["186.155.15.156/32"]
}
*/

/*
resource "aws_security_group_rule" "ingress_from_local_home_to_50051" {
  security_group_id = aws_security_group.the_security_group.id
  description       = "ingress_from_home_to_50051"
  type              = "ingress"
  from_port         = 50051
  to_port           = 50051
  protocol          = "tcp"
  cidr_blocks      = ["${data.http.local_home_ip_address.response_body}/32"]
}

resource "aws_security_group_rule" "ingress_from_local_home_to_8080" {
  security_group_id = aws_security_group.the_security_group.id
  description       = "ingress_from_home_to_8080"
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks      = ["${data.http.local_home_ip_address.response_body}/32"]
}

resource "aws_security_group_rule" "ingress_from_local_home_to_80" {
  security_group_id = aws_security_group.the_security_group.id
  description       = "ingress_from_home_to_80"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks      = ["${data.http.local_home_ip_address.response_body}/32"]
}

resource "aws_security_group_rule" "ingress_from_local_home_to_443" {
  security_group_id = aws_security_group.the_security_group.id
  description       = "ingress_from_home_to_443"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks      = ["${data.http.local_home_ip_address.response_body}/32"]
}
*/
resource "aws_security_group_rule" "egress_to_everywhere" {
  security_group_id = aws_security_group.the_security_group.id
  description       = "egress_to_everywhere"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks      = ["0.0.0.0/0"]
}

##################################################################################
# aws_security_group - OUTPUT
##################################################################################

output "security_group" {
  description = "Security Group "
  value = aws_security_group.the_security_group
}

output "security_group_name" {
  description = "Security Group Name"
  value = aws_security_group.the_security_group.name
}

output "security_group_id" {
  description = "Security Group Id"
  value = aws_security_group.the_security_group.id
}

output "security_group_vpc_id" {
  description = "Security Group Vpc Id"
  value = aws_security_group.the_security_group.vpc_id
}

output "vpc_id" {
  description = "Local Home Ip Address"
  value = aws_default_vpc.default.id
}

output "local_home_ip_address" {
  value = data.http.local_home_ip_address.response_body
}
