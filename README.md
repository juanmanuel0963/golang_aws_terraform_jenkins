<!-- BEGIN_TF_DOCS -->
# AWS WITH TERRAFORM AND GOLANG
This repo contains several examples of AWS Services created with Terraform as well a microservices backend composed of REST and GRPC microservices in Golang.

## Terraform
Every single AWS Service in this lab has been created with Terraform sentences.
This lab demostrates the ability to update any AWS infrastructure with a platform as code approach with Terraform.
The only procedure we do manually is the creation of accounts, users, roles and key pairs with AWS IAM.

The ./main.tf file is the lab backbone. It links to submodules inside below subfolders:
- networking
- api_gateway
- db_postgresql
- microservices
- ec2

## Jenkins
The infraestructure updates and the Golang code can be automatically deployed with Terraform commands or with Jenkins Pipelines to DEV, QAT, NFT or PROD environments.
The Jenkins server has been created and configured manually on a AWS EC2 instance.
In this repo we just share screenshots of the Jenkins pipeline configuration (jenkins-config folder).
The Jenkins pipeline reads this Github repo and executes commands on a AWS account.
The Jenkins pipeline can be executed manually or configure to deploy code automatically (every hour, day, etc).

## AWS EC2 instances, Public IP, VPC, Security Group
In this lab we create two EC2 instances (client and server) for the purpose of deploying grpc microservices in golang.
Each EC2 instance is associated to a public IP, VPC and security group. 
The security group is configure with ingress and egress rules.

## AWS RDS Postgresql
AWS RDS Postgresql

## AWS API Gateway
AWS API Gateway

## AWS Lambda Functions Golang microservices
AWS Lambda microservices in Golang

## GRPC Golang microservices
GRPC microservices in Golang

## AWS Eventbridge
AWS Eventbridge