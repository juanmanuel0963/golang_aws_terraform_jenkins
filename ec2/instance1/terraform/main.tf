
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

variable "ami_id" {
  description = "AMI for Ubuntu Ec2 instance"
  type    = string
}

variable "instance_type" {
  description = "Instance type for EC2"
  type    = string
}

variable "key_name" {
  description = "SSH keys to connect to EC2 instance"
  type    = string
}

variable "tag_name" {
  description = "Name for this EC2 instance"
  type    = string
}

variable "associate_public_ip_address" {
  description = "Associated public ip address"
  type    = bool
}

variable "vpc_id"{
  description = "Id of VPC"
  type    = string
}

variable "security_group_id"{
  description = "Id of security group"
  type    = string
}

locals {
  availability_zone = "${var.region}c"  
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

//----------Creates the AWS EC2 instance----------

resource "aws_instance" "the_instance" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  availability_zone = local.availability_zone
  associate_public_ip_address = var.associate_public_ip_address
  key_name        = var.key_name
  
  vpc_security_group_ids = [
    var.security_group_id
  ]

  tags  = {
    Name = var.tag_name
  }

  root_block_device {
    delete_on_termination = true
    volume_size = 8
    volume_type = "gp2"
  }

  private_dns_name_options{
    enable_resource_name_dns_a_record = true
    hostname_type = "ip-name"
  }

  depends_on = [ var.security_group_id ]
}

//----------Associating Public IP----------

resource "aws_eip" "lb" {
  instance = aws_instance.the_instance.id
  vpc      = true
}

##################################################################################
# aws_instance - OUTPUT
##################################################################################

output "aws_instance_id" {
  description = "Instance Id"
  value = aws_instance.the_instance.id
}

output "aws_instance_name" {
  description = "Instance Name"
  value = aws_instance.the_instance.tags
}

output "aws_instance_public_ip" {
  description = "Public IP"
  value = aws_instance.the_instance.public_ip
}

output "aws_instance_private_ip" {
  description = "Private IP"
  value = aws_instance.the_instance.private_ip
}

