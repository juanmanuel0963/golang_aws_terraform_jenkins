region                  = "us-east-1"
access_key              = ""
secret_key              = ""
#db_postgresql
identifier              = "db-server-postgresql"
storage_type            = "gp2"  
allocated_storage       = 20
engine                  = "postgres"
engine_version          = "13.7"
instance_class          = "db.t3.micro"
port                    = "5432"
db_name                 = "db_postgresql"
username                = "db_master"
password                = "Goraherria100"
parameter_group_name    = "default.postgres13"
publicly_accessible     = true
deletion_protection     = true
skip_final_snapshot     = true
backup_retention_period = 0
backup_window           = "21:00-21:30"
maintenance_window      = "Fri:21:30-Fri:22:00"
apply_immediately       = true
#grpc_server_1
ami_id                  = "ami-0149b2da6ceec4bb0"
instance_type           = "t2.micro"
key_name                = "dev.workloads.key_pair"
#
grpc_server_1_instance_name     = "grpc_server_1"
grpc_server_1_tag_name          = "grpc_server_1 - Ubuntu 1GB"
grpc_server_1_server_install    = "software_install"
grpc_server_1_op1_function_name = "op1_usermgmt_server"
grpc_server_1_op2_function_name = "op2_usermgmt_server"
grpc_server_1_op3_function_name = "op3_usermgmt_server"
grpc_server_1_op4_function_name = "op4_usermgmt_server"
#grpc_client_1
grpc_client_1_instance_name     = "grpc_client_1"
grpc_client_1_tag_name          = "grpc_client_1 - Ubuntu 1GB"
grpc_client_1_client_install    = "software_install"
grpc_client_1_op1_function_name = "op1_usermgmt_client"
grpc_client_1_op2_function_name = "op2_usermgmt_client" 
grpc_client_1_op3_function_name = "op3_usermgmt_client" 
grpc_client_1_op4_function_name = "op4_usermgmt_client" 