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

locals {
  availability_zone       = "${var.region}c"
  user_pool_name   = "user_pool_${var.random_pet}"
  app_client_name   = "app_client_${var.random_pet}"
  resource_server_name   = "resource_server_name_${var.random_pet}"
  resource_server_id   = "resource_server_id_${var.random_pet}"
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

//----------Cognito User Pool creation----------
//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool#admin_create_user_config
//Provides a Cognito User Pool resource.
resource "aws_cognito_user_pool" "the_pool" {
  name = local.user_pool_name

  admin_create_user_config{
    allow_admin_create_user_only = true
  }

  alias_attributes = ["email"]
  auto_verified_attributes = ["email"]
}


//----------App Client creation----------
//https://registry.terraform.io/providers/hashicorp/aws/2.41.0/docs/resources/cognito_user_pool_client
resource "aws_cognito_user_pool_client" "the_app_client" {
  name = local.app_client_name
  user_pool_id = "${aws_cognito_user_pool.the_pool.id}"
  generate_secret     = true
}

//----------Resource Server----------
//https://registry.terraform.io/providers/hashicorp/aws/2.41.0/docs/resources/cognito_resource_server
resource "aws_cognito_resource_server" "the_resource_server" {
  identifier = local.resource_server_id
  name       = local.resource_server_name
  user_pool_id = "${aws_cognito_user_pool.the_pool.id}"

  scope {
    scope_name        = "read"
    scope_description = "for GET"
  }

  scope {
    scope_name        = "write"
    scope_description = "for POST"
  }
}

//----------User----------
//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user
resource "aws_cognito_user" "example" {
  user_pool_id = "${aws_cognito_user_pool.the_pool.id}"
  username     = "example"
  attributes = {
    email          = "no-reply@hashicorp.com"
    email_verified = true
  }
}
##################################################################################
# aws_cognito_user_pool - OUTPUT
##################################################################################

output "aws_cognito_user_pool_id" {
  description = "Cognito User pool ID"
  value = aws_cognito_user_pool.the_pool.id
}

output "aws_cognito_user_pool_name" {
  description = "Cognito User pool name"
  value = aws_cognito_user_pool.the_pool.name
}

output "aws_cognito_user_pool_app_client_id" {
  description = "Cognito client app ID"
  value = aws_cognito_user_pool_client.the_app_client.id
}

output "aws_cognito_user_pool_app_client_name" {
  description = "Cognito client app name"
  value = aws_cognito_user_pool_client.the_app_client.name
}

output "aws_cognito_resource_server_name" {
  description = "Resource server name"
  value = aws_cognito_resource_server.the_resource_server.name
}

output "aws_cognito_resource_server_identifier" {
  description = "Resource server identifier"
  value = aws_cognito_resource_server.the_resource_server.identifier
}