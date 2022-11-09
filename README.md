<!-- BEGIN_TF_DOCS -->
# AWS WITH TERRAFORM AND GOLANG LABORATORY
This repo contains several examples of AWS Services created with Terraform as well a microservices backend composed of REST and GRPC microservices in Golang.

## Terraform
Every single AWS Service in this lab has been created with Terraform sentences.
This lab demostrates the ability to update any AWS platform as code with Terraform.
The only procedure we do manually is the creation of accounts, users, roles and key pairs with AWS IAM.

The ./main.tf file is the lab backbone. It makes reference to terraform submodules inside below subfolders:
- networkinbg
- api_gateway
- db_postgresql
- microservices
- ec2

## Jenkins
The platform update instructions and the Golang microservices can be automatically deployed with Terraform commands or with Jenkins Pipelines to DEV, QAT, NFT or PROD environments.
In this repo we just show screenshots for Jenkins pipeline configuration (jenkins-config folder).
The Jenkins server has been creaed and configured on a AWS EC2 instance.
The Jenkins pipeline reads this Github repo and executes commands on a AWS account.
The Jenkins pipeline can be executed manually or configure to deploy code automatically (every hour, day, etc).

## AWS EC2 instances, Public IP, VPC, Security Group
In this lab we create 2 EC2 instances (client and server) for the purpose of testing grpc microservices in golang.
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