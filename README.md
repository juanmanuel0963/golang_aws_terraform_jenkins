<!-- BEGIN_TF_DOCS -->
# Backend microservices architecture with Terraform and Golang
This repo contains different alternatives for creation of APIs microservices written with Golang and backend infrastructure as code with Terraform and AWS.

<img src="architecture_diagram.png"/>

## Terraform
Every single AWS Service in this lab has been created with Terraform sentences.
This lab demostrates the ability to update any AWS infrastructure with a platform as code approach with Terraform.
The only procedure we do manually is the creation of accounts, users, roles and key pairs with AWS IAM.

The ./main.tf file is the lab backbone. It links to submodules inside below subfolders:
- networking
- api_gateway
- db_postgresql
- microservices (lambda functions, gRPC)
- ec2

## Jenkins CI/CD
The infraestructure updates and the Golang code can be automatically deployed with Terraform commands or with Jenkins Pipelines to DEV, QAT, NFT or PROD environments.
The Jenkins server has been created and configured manually on a AWS EC2 instance.
In this repo we just share screenshots of the Jenkins pipeline configuration (jenkins-config folder).
The Jenkins pipeline reads this Github repo and executes commands on a AWS account.
The Jenkins pipeline can be executed manually or configure to deploy code automatically (every hour, day, etc).

## AWS EC2 instances, Public IP, VPC, Security Group
In this lab we create two EC2 instances (client and server) for the purpose of deploying gRPC microservices in golang.
Each EC2 instance is associated to a public IP, VPC and security group. 
The security group is configure with ingress and egress rules.
Every suitable resource is created behind the same VPC and security group.

## AWS RDS Postgresql
In this lab we create one AWS RDS Postgresql database.
The DB model has two tables (companies and contacts).
All the DB resources are created with sql statements straight into the database (tables, relationsips, CRUD operations and load of test data).
We have two special sql functions: one for dynamic filtering and one for query pagination.
These CRUD functions are call by AWS Lambda functions.

## AWS API Gateway
The main purpose of this lab is to show how to create a microservices backend with AWS, lambda functions and gRPC functions written in Golang.
So the first step is to expose an API which is publicly available.

## AWS Eventbridge
AWS Eventbridge is used to orquestrate the integration between the AWS API Gateway and the gRPC services running in the EC2 instances.
A patern rule is created in EventBridge. Once the rule is satisfied, it executes a target Run Command (linux commands) into the EC2 to call a client gRPC function.
Also a schedule rule is created to execute a Run Command to execute a call to a client gRPC function.

## AWS Lambda Functions Golang microservices
The API invokes lambda functions written in golang to update DB contacts.
The lambda functions are secured with IAM authentication, so the client needs to send AWS Signature for authentication (AccessKey and SecretKey).
The lambda functions write detailed logs into the AWS CloudWatch event log.
The lambda functions execute the CRUD operations calling the in database functions.
The microservices can perform this operations:

- contacts delete by contact id
- contacts get by compamy id
- contacts get by contact id
- contacts get by dynamic filter
- contacts get by pagination
- contacts insert
- contacts update by contact id

## gRPC Golang microservices
Some API services are integrated to AWS EventBridge rules which fire gRPC functions running in a EC2 instance (client).
Once the client is invoked then it calls the corresponding gRPC function running in the EC2 server instance.
The microservices can perform this operations:

- usermgmt no persistence
- usermgmt in memory no persistence
- usermgmt json file persistence
- usermgmt db postgres persistence

https://www.linkedin.com/in/juanmanuel0963/