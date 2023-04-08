<!-- BEGIN_TF_DOCS -->
# Creating a backend microservices architecture with Golang and Terraform.

This repository aims to demonstrate how we can implement 3 different types of microservices in our backend projects. These 3 types of microservices are: lambda functions, RESTful microservices, and gRPC microservices.

<img src="images/linkedin.png"/> https://www.linkedin.com/in/juanmanuel0963/

<img src="images/architecture_diagram.png"/>

We will be using AWS as our cloud platform. We will be using Golang as our programming language. Github will be our code repository. We will programmatically define the AWS infrastructure and services we will be implementing using Terraform.

We will also be using Terraform to deploy the infrastructure and functional code to the Development and Testing environments. For deploying the infrastructure and functional code to the Production environment, we will be using Jenkins.

## Definition of environments
For our project, we will define 3 types of environments: Development, Testing, and Production. Previously, we should have created 3 independent accounts within our Organization.

The creation of the Organization and the creation of Accounts are outside the scope of this guide.

## Defining infrastructure with Terraform
The backbone for creating infrastructure resources is the <a href="main.tf" target="_blank">main.tf</a> file, which is located in the root folder. This file in turn refers to sub-files with specific content for configuring and creating resources. Configuration variables are located in the <a href="terraform.tfvars" target="_blank">terraform.tfvars</a> file.

## Network-level security
Within each account/environment, we will specify the availability zone we want to use. Within the default assigned Virtual Private Network, we will create a Security Group. 
This Security Group will allow us to define the inbound and outbound rules we need to interact with our infrastructure resources, such as Databases or EC2 instances.

<a href="main.tf" target="_blank">main.tf</a>

<img src="images/networking.png"/>

<a href="networking/terraform/main.tf" target="_blank">networking/terraform/main.tf</a>

<img src="images/networking_resources.png"/>

## Creating the Postgresql database. 
We create the database within the same Security Group defined earlier. The configuration parameters, such as machine type, instance type, and allocated memory space, are brought from the terraform.tfvars file.

<a href="main.tf" target="_blank">main.tf</a>

<img src="images/postgresql.png"/>

<a href="db_postgresql/terraform/main.tf" target="_blank">db_postgresql/terraform/main.tf</a>

<img src="images/postgresql_resources.png"/>

<a href="terraform.tfvars" target="_blank">terraform.tfvars</a>

<img src="images/postgresql_variables.png"/>

## Creating the API Gateway 
The API Gateway will allow us to access a collection of microservices under the same domain name. In this project, the API Gateway will give us access to lambda functions to perform CRUD operations on a Contacts table.

<a href="main.tf" target="_blank">./main.tf</a>

<img src="images/api_gateway.png"/>

<a href="api_gateway/terraform/main.tf" target="_blank">api_gateway/terraform/main.tf</a>

<img src="images/api_gateway_resources.png"/>



## Creating lambda functions. 
The next step is to create the lambda functions and associate them with the API Gateway we just created. We are going to create several functions int Golang to perform CRUD operations, as well as more specialized functions to perform searches through dynamic filters or paginated searches. The lambda functions that we will create and associate with the API Gateway are as follows:

&#x2022; contacts insert

&#x2022; contacts get by company id

&#x2022; contacts get by contact id

&#x2022; contacts delete by contact id

&#x2022; contacts update by contact id

&#x2022; contacts get by dynamic filter

&#x2022; contacts get by pagination

As always, everything starts with the main.tf file located in the root folder.

<a href="main.tf" target="_blank">main.tf</a>

<img src="images/contacts_insert.png"/>

<a href="./microservices_restful_lambda/contacts_insert/terraform/main.tf" target="_blank">microservices_restful_lambda/contacts_insert/terraform/main.tf</a>

<img src="images/contacts_insert_resources_1.png"/>


