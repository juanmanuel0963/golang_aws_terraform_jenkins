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

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

resource "random_pet" "api_gateway" {
  length = 2
}

locals {
  random_integer = "${random_integer.rand.result}"
  random_pet = "${replace("${random_pet.api_gateway.id}", "-", "_")}"
}

##################################################################################
# networking
##################################################################################

module "module_networking" {
    source              = "./networking/terraform"
    region              = var.region  
    access_key          = var.access_key
    secret_key          = var.secret_key    
    security_group_name = "sg_${local.random_pet}"    
}

##################################################################################
# networking - OUTPUT
##################################################################################

output "module_networking_security_group_name" {
  description = "Security Group Name"
  value = module.module_networking.security_group_name
}

output "module_networking_security_group_id" {
  description = "Security Group Id"
  value = module.module_networking.security_group_id
}

output "module_networking_security_group_vpc_id" {
  description = "Security Group Vpc Id"
  value = module.module_networking.security_group_vpc_id
}

output "module_networking_vpc_id" {
  description = "Vpc Id"
  value = module.module_networking.vpc_id
}

output "module_networking_local_home_ip_address" {
  description = "Local Home Ip Address"
  value = module.module_networking.local_home_ip_address
}

##################################################################################
# api_gateway
##################################################################################

module "module_api_gateway" {
    source            = "./api_gateway/terraform"
    region            = var.region  
    access_key        = var.access_key
    secret_key        = var.secret_key
    api_gateway_name  = "api_gateway_${local.random_pet}"
}

##################################################################################
# api_gateway - OUTPUT
##################################################################################

output "module_api_gateway_id" {
  description = "Id of the API Gateway."
  value = module.module_api_gateway.api_gateway_id
}

output "module_api_gateway_name" {
  description = "Name of the API Gateway."
  value = module.module_api_gateway.api_gateway_name
}

output "module_api_gateway_execution_arn" {
  description = "Execution arn of the API Gateway."
  value = module.module_api_gateway.api_gateway_execution_arn
}

output "module_api_gateway_invoke_url" {
  description = "Base URL for API Gateway stage."
  value = module.module_api_gateway.api_gateway_invoke_url
}


#############################################################################
# VARIABLES - db_postgresql
#############################################################################

variable "identifier" {
  type    = string
}

variable "storage_type" {
  type    = string
}

variable "allocated_storage" {
  type    = string
}

variable "engine" {
  type    = string
}

variable "engine_version" {
  type    = string
}

variable "instance_class" {
  type    = string
}

variable "port" {
  type    = string
}

variable "db_name" {
  type    = string
}

variable "username" {
  type    = string
}

variable "password" {
  type    = string
}

variable "parameter_group_name" {
  type    = string
}

variable "publicly_accessible" {
  type    = bool
}

variable "deletion_protection" {
  type    = bool
}

variable "skip_final_snapshot" {
  type    = bool
}


##################################################################################
# db_postgresql
##################################################################################

module "module_db_postgresql" {
    source                  = "./db_postgresql/terraform"
    region                  = var.region  
    access_key              = var.access_key
    secret_key              = var.secret_key
    identifier              = var.identifier
    storage_type            = var.storage_type
    allocated_storage       = var.allocated_storage
    engine                  = var.engine
    engine_version          = var.engine_version
    instance_class          = var.instance_class
    port                    = var.port
    db_name                 = var.db_name
    username                = var.username
    password                = var.password
    parameter_group_name    = var.parameter_group_name
    publicly_accessible     = var.publicly_accessible
    deletion_protection     = var.deletion_protection
    skip_final_snapshot     = var.skip_final_snapshot
    random_pet              = local.random_pet
    vpc_id                  = module.module_networking.vpc_id 
    security_group_id       = module.module_networking.security_group_id
}

##################################################################################
# db_postgresql - OUTPUT
##################################################################################

output "module_db_postgresql_aws_db_instance_identifier" {
  description = "Server Name"
  value = module.module_db_postgresql.aws_db_instance_identifier
}

output "module_db_postgresql_aws_db_instance_db_name" {
  description = "DB Name"
  value = module.module_db_postgresql.aws_db_instance_db_name
}

output "module_db_postgresql_aws_db_instance_vpc_security_group_ids" {
  description = "Security Group"
  value = module.module_db_postgresql.aws_db_instance_vpc_security_group_ids
}

output "module_db_postgresql_aws_db_instance_db_subnet_group_name" {
  description = "Subnet Group"
  value = module.module_db_postgresql.aws_db_instance_db_subnet_group_name
}

output "module_db_postgresql_aws_db_instance_endpoint" {
  description = "Endpoint"
  value = module.module_db_postgresql.aws_db_instance_endpoint
}

##################################################################################
# lambda_func_node
##################################################################################

module "module_lambda_func_node" {
    source                            = "./microservices/lambda_func_node/terraform"
    region                            = var.region  
    access_key                        = var.access_key 
    secret_key                        = var.secret_key
    lambda_func_name                  = "lambda_func_node"    
    random_integer                    = local.random_integer
    random_pet                        = local.random_pet
    parent_api_gateway_id             = module.module_api_gateway.api_gateway_id
    parent_api_gateway_name           = module.module_api_gateway.api_gateway_name
    parent_api_gateway_execution_arn  = module.module_api_gateway.api_gateway_execution_arn
    parent_api_gateway_invoke_url     = module.module_api_gateway.api_gateway_invoke_url        
}

##################################################################################
# lambda_func_node - OUTPUT
##################################################################################

output "module_lambda_func_node_lambda_func_name" {
  description = "Name of the Lambda function."
  value = module.module_lambda_func_node.lambda_func_name
}

output "module_lambda_func_node_lambda_func_bucket_name" {
  description = "Name of the S3 bucket used to store function code."
  value = module.module_lambda_func_node.lambda_func_bucket_name
}

output "module_lambda_func_node_lambda_func_role_name" {
  description = "Name of the rol"
  value = module.module_lambda_func_node.lambda_func_role_name
}

output "module_lambda_func_node_lambda_func_base_url" {
  description = "Base URL for API Gateway stage + function name"
  value = module.module_lambda_func_node.lambda_func_base_url
}

##################################################################################
# lambda_func_go
##################################################################################

module "module_lambda_func_go" {
    source                            = "./microservices/lambda_func_go/terraform"
    region                            = var.region  
    access_key                        = var.access_key 
    secret_key                        = var.secret_key
    lambda_func_name                  = "lambda_func_go"
    random_integer                    = local.random_integer
    random_pet                        = local.random_pet
    parent_api_gateway_id             = module.module_api_gateway.api_gateway_id
    parent_api_gateway_name           = module.module_api_gateway.api_gateway_name
    parent_api_gateway_execution_arn  = module.module_api_gateway.api_gateway_execution_arn
    parent_api_gateway_invoke_url     = module.module_api_gateway.api_gateway_invoke_url    
}

##################################################################################
# lambda_func_go - OUTPUT
##################################################################################

output "module_lambda_func_go_lambda_func_name" {
  description = "Name of the Lambda function."
  value = module.module_lambda_func_go.lambda_func_name
}

output "module_lambda_func_go_lambda_func_bucket_name" {
  description = "Name of the S3 bucket used to store function code."
  value = module.module_lambda_func_go.lambda_func_bucket_name
}

output "module_lambda_func_go_lambda_func_role_name" {
  description = "Name of the rol"
  value = module.module_lambda_func_go.lambda_func_role_name
}

output "module_lambda_func_go_lambda_func_base_url" {
  description = "Base URL for API Gateway stage + function name"
  value = module.module_lambda_func_go.lambda_func_base_url
}


##################################################################################
# contacts_insert
##################################################################################

module "module_contacts_insert" {
    source                            = "./microservices/contacts_insert/terraform"
    region                            = var.region  
    access_key                        = var.access_key 
    secret_key                        = var.secret_key
    lambda_func_name                  = "contacts_insert"
    random_integer                    = local.random_integer
    random_pet                        = local.random_pet
    parent_api_gateway_id             = module.module_api_gateway.api_gateway_id
    parent_api_gateway_name           = module.module_api_gateway.api_gateway_name
    parent_api_gateway_execution_arn  = module.module_api_gateway.api_gateway_execution_arn
    parent_api_gateway_invoke_url     = module.module_api_gateway.api_gateway_invoke_url    
    InstanceConnectionName            = module.module_db_postgresql.aws_db_instance_endpoint
    dbName                            = module.module_db_postgresql.aws_db_instance_db_name
    dbUser                            = var.username
    dbPassword                        = var.password        
    vpc_id                            = module.module_networking.vpc_id 
    security_group_id                 = module.module_networking.security_group_id
}

##################################################################################
# contacts_insert - OUTPUT
##################################################################################

output "module_contacts_insert_lambda_func_name" {
  description = "Name of the Lambda function."
  value = module.module_contacts_insert.lambda_func_name
}

output "module_contacts_insert_lambda_func_bucket_name" {
  description = "Name of the S3 bucket used to store function code."
  value = module.module_contacts_insert.lambda_func_bucket_name
}

output "module_contacts_insert_lambda_func_role_name" {
  description = "Name of the rol"
  value = module.module_contacts_insert.lambda_func_role_name
}

output "module_contacts_insert_lambda_func_base_url" {
  description = "Base URL for API Gateway stage + function name"
  value = module.module_contacts_insert.lambda_func_base_url
}


##################################################################################
# contacts_get_by_contact_id
##################################################################################

module "module_contacts_get_by_contact_id" {
    source                            = "./microservices/contacts_get_by_contact_id/terraform"
    region                            = var.region  
    access_key                        = var.access_key 
    secret_key                        = var.secret_key
    lambda_func_name                  = "contacts_get_by_contact_id"
    random_integer                    = local.random_integer
    random_pet                        = local.random_pet
    parent_api_gateway_id             = module.module_api_gateway.api_gateway_id
    parent_api_gateway_name           = module.module_api_gateway.api_gateway_name
    parent_api_gateway_execution_arn  = module.module_api_gateway.api_gateway_execution_arn
    parent_api_gateway_invoke_url     = module.module_api_gateway.api_gateway_invoke_url    
    InstanceConnectionName            = module.module_db_postgresql.aws_db_instance_endpoint
    dbName                            = module.module_db_postgresql.aws_db_instance_db_name
    dbUser                            = var.username
    dbPassword                        = var.password        
    vpc_id                            = module.module_networking.vpc_id 
    security_group_id                 = module.module_networking.security_group_id
}

##################################################################################
# contacts_get_by_contact_id - OUTPUT
##################################################################################

output "module_contacts_get_by_contact_id_lambda_func_name" {
  description = "Name of the Lambda function."
  value = module.module_contacts_get_by_contact_id.lambda_func_name
}

output "module_contacts_get_by_contact_id_lambda_func_bucket_name" {
  description = "Name of the S3 bucket used to store function code."
  value = module.module_contacts_get_by_contact_id.lambda_func_bucket_name
}

output "module_contacts_get_by_contact_id_lambda_func_role_name" {
  description = "Name of the rol"
  value = module.module_contacts_get_by_contact_id.lambda_func_role_name
}

output "module_contacts_get_by_contact_id_lambda_func_base_url" {
  description = "Base URL for API Gateway stage + function name"
  value = module.module_contacts_get_by_contact_id.lambda_func_base_url
}

##################################################################################
# contacts_get_by_company_id
##################################################################################

module "module_contacts_get_by_company_id" {
    source                            = "./microservices/contacts_get_by_company_id/terraform"
    region                            = var.region  
    access_key                        = var.access_key 
    secret_key                        = var.secret_key
    lambda_func_name                  = "contacts_get_by_company_id"
    random_integer                    = local.random_integer
    random_pet                        = local.random_pet
    parent_api_gateway_id             = module.module_api_gateway.api_gateway_id
    parent_api_gateway_name           = module.module_api_gateway.api_gateway_name
    parent_api_gateway_execution_arn  = module.module_api_gateway.api_gateway_execution_arn
    parent_api_gateway_invoke_url     = module.module_api_gateway.api_gateway_invoke_url    
    InstanceConnectionName            = module.module_db_postgresql.aws_db_instance_endpoint
    dbName                            = module.module_db_postgresql.aws_db_instance_db_name
    dbUser                            = var.username
    dbPassword                        = var.password        
    vpc_id                            = module.module_networking.vpc_id 
    security_group_id                 = module.module_networking.security_group_id
}

##################################################################################
# contacts_get_by_company_id - OUTPUT
##################################################################################

output "module_contacts_get_by_company_id_lambda_func_name" {
  description = "Name of the Lambda function."
  value = module.module_contacts_get_by_company_id.lambda_func_name
}

output "module_contacts_get_by_company_id_lambda_func_bucket_name" {
  description = "Name of the S3 bucket used to store function code."
  value = module.module_contacts_get_by_company_id.lambda_func_bucket_name
}

output "module_contacts_get_by_company_id_lambda_func_role_name" {
  description = "Name of the rol"
  value = module.module_contacts_get_by_company_id.lambda_func_role_name
}

output "module_contacts_get_by_company_id_lambda_func_base_url" {
  description = "Base URL for API Gateway stage + function name"
  value = module.module_contacts_get_by_company_id.lambda_func_base_url
}

##################################################################################
# contacts_update_by_contact_id
##################################################################################

module "module_contacts_update_by_contact_id" {
    source                            = "./microservices/contacts_update_by_contact_id/terraform"
    region                            = var.region  
    access_key                        = var.access_key 
    secret_key                        = var.secret_key
    lambda_func_name                  = "contacts_update_by_contact_id"
    random_integer                    = local.random_integer
    random_pet                        = local.random_pet
    parent_api_gateway_id             = module.module_api_gateway.api_gateway_id
    parent_api_gateway_name           = module.module_api_gateway.api_gateway_name
    parent_api_gateway_execution_arn  = module.module_api_gateway.api_gateway_execution_arn
    parent_api_gateway_invoke_url     = module.module_api_gateway.api_gateway_invoke_url    
    InstanceConnectionName            = module.module_db_postgresql.aws_db_instance_endpoint
    dbName                            = module.module_db_postgresql.aws_db_instance_db_name
    dbUser                            = var.username
    dbPassword                        = var.password        
    vpc_id                            = module.module_networking.vpc_id 
    security_group_id                 = module.module_networking.security_group_id
}

##################################################################################
# contacts_update_by_contact_id - OUTPUT
##################################################################################

output "module_contacts_update_by_contact_id_lambda_func_name" {
  description = "Name of the Lambda function."
  value = module.module_contacts_update_by_contact_id.lambda_func_name
}

output "module_contacts_update_by_contact_id_lambda_func_bucket_name" {
  description = "Name of the S3 bucket used to store function code."
  value = module.module_contacts_update_by_contact_id.lambda_func_bucket_name
}

output "module_contacts_update_by_contact_id_lambda_func_role_name" {
  description = "Name of the rol"
  value = module.module_contacts_update_by_contact_id.lambda_func_role_name
}

output "module_contacts_update_by_contact_id_lambda_func_base_url" {
  description = "Base URL for API Gateway stage + function name"
  value = module.module_contacts_update_by_contact_id.lambda_func_base_url
}

##################################################################################
# contacts_delete_by_contact_id
##################################################################################

module "module_contacts_delete_by_contact_id" {
    source                            = "./microservices/contacts_delete_by_contact_id/terraform"
    region                            = var.region  
    access_key                        = var.access_key 
    secret_key                        = var.secret_key
    lambda_func_name                  = "contacts_delete_by_contact_id"
    random_integer                    = local.random_integer
    random_pet                        = local.random_pet
    parent_api_gateway_id             = module.module_api_gateway.api_gateway_id
    parent_api_gateway_name           = module.module_api_gateway.api_gateway_name
    parent_api_gateway_execution_arn  = module.module_api_gateway.api_gateway_execution_arn
    parent_api_gateway_invoke_url     = module.module_api_gateway.api_gateway_invoke_url    
    InstanceConnectionName            = module.module_db_postgresql.aws_db_instance_endpoint
    dbName                            = module.module_db_postgresql.aws_db_instance_db_name
    dbUser                            = var.username
    dbPassword                        = var.password        
    vpc_id                            = module.module_networking.vpc_id 
    security_group_id                 = module.module_networking.security_group_id
}

##################################################################################
# contacts_delete_by_contact_id - OUTPUT
##################################################################################

output "module_contacts_delete_by_contact_id_lambda_func_name" {
  description = "Name of the Lambda function."
  value = module.module_contacts_delete_by_contact_id.lambda_func_name
}

output "module_contacts_delete_by_contact_id_lambda_func_bucket_name" {
  description = "Name of the S3 bucket used to store function code."
  value = module.module_contacts_delete_by_contact_id.lambda_func_bucket_name
}

output "module_contacts_delete_by_contact_id_lambda_func_role_name" {
  description = "Name of the rol"
  value = module.module_contacts_delete_by_contact_id.lambda_func_role_name
}

output "module_contacts_delete_by_contact_id_lambda_func_base_url" {
  description = "Base URL for API Gateway stage + function name"
  value = module.module_contacts_delete_by_contact_id.lambda_func_base_url
}

##################################################################################
# contacts_get_by_dynamic_filter
##################################################################################

module "module_contacts_get_by_dynamic_filter" {
    source                            = "./microservices/contacts_get_by_dynamic_filter/terraform"
    region                            = var.region  
    access_key                        = var.access_key 
    secret_key                        = var.secret_key
    lambda_func_name                  = "contacts_get_by_dynamic_filter"
    random_integer                    = local.random_integer
    random_pet                        = local.random_pet
    parent_api_gateway_id             = module.module_api_gateway.api_gateway_id
    parent_api_gateway_name           = module.module_api_gateway.api_gateway_name
    parent_api_gateway_execution_arn  = module.module_api_gateway.api_gateway_execution_arn
    parent_api_gateway_invoke_url     = module.module_api_gateway.api_gateway_invoke_url    
    InstanceConnectionName            = module.module_db_postgresql.aws_db_instance_endpoint
    dbName                            = module.module_db_postgresql.aws_db_instance_db_name
    dbUser                            = var.username
    dbPassword                        = var.password        
    vpc_id                            = module.module_networking.vpc_id 
    security_group_id                 = module.module_networking.security_group_id
}

##################################################################################
# contacts_get_by_dynamic_filter - OUTPUT
##################################################################################

output "module_contacts_get_by_dynamic_filter_lambda_func_name" {
  description = "Name of the Lambda function."
  value = module.module_contacts_get_by_dynamic_filter.lambda_func_name
}

output "module_contacts_get_by_dynamic_filter_lambda_func_bucket_name" {
  description = "Name of the S3 bucket used to store function code."
  value = module.module_contacts_get_by_dynamic_filter.lambda_func_bucket_name
}

output "module_contacts_get_by_dynamic_filter_lambda_func_role_name" {
  description = "Name of the rol"
  value = module.module_contacts_get_by_dynamic_filter.lambda_func_role_name
}

output "module_contacts_get_by_dynamic_filter_lambda_func_base_url" {
  description = "Base URL for API Gateway stage + function name"
  value = module.module_contacts_get_by_dynamic_filter.lambda_func_base_url
}

##################################################################################
# contacts_get_by_pagination
##################################################################################

module "module_contacts_get_by_pagination" {
    source                            = "./microservices/contacts_get_by_pagination/terraform"
    region                            = var.region  
    access_key                        = var.access_key 
    secret_key                        = var.secret_key
    lambda_func_name                  = "contacts_get_by_pagination"
    random_integer                    = local.random_integer
    random_pet                        = local.random_pet
    parent_api_gateway_id             = module.module_api_gateway.api_gateway_id
    parent_api_gateway_name           = module.module_api_gateway.api_gateway_name
    parent_api_gateway_execution_arn  = module.module_api_gateway.api_gateway_execution_arn
    parent_api_gateway_invoke_url     = module.module_api_gateway.api_gateway_invoke_url    
    InstanceConnectionName            = module.module_db_postgresql.aws_db_instance_endpoint
    dbName                            = module.module_db_postgresql.aws_db_instance_db_name
    dbUser                            = var.username
    dbPassword                        = var.password        
    vpc_id                            = module.module_networking.vpc_id 
    security_group_id                 = module.module_networking.security_group_id
}

##################################################################################
# contacts_get_by_pagination - OUTPUT
##################################################################################

output "module_contacts_get_by_pagination_lambda_func_name" {
  description = "Name of the Lambda function."
  value = module.module_contacts_get_by_pagination.lambda_func_name
}

output "module_contacts_get_by_pagination_lambda_func_bucket_name" {
  description = "Name of the S3 bucket used to store function code."
  value = module.module_contacts_get_by_pagination.lambda_func_bucket_name
}

output "module_contacts_get_by_pagination_lambda_func_role_name" {
  description = "Name of the rol"
  value = module.module_contacts_get_by_pagination.lambda_func_role_name
}

output "module_contacts_get_by_pagination_lambda_func_base_url" {
  description = "Base URL for API Gateway stage + function name"
  value = module.module_contacts_get_by_pagination.lambda_func_base_url
}