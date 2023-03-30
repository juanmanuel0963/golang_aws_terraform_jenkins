::Compiling binaries to upload to AWS
set GOOS=linux
::ls env:
::set $Env:GOOS=linux
::--------DB migrate--------
cd D:\projects\golang_aws_terraform_jenkins\microservices_restful_ec2\_database\migrate
go build migrate.go

::Blogs-------------
::Blogs - web server
cd D:\projects\golang_aws_terraform_jenkins\microservices_restful_ec2\blogs\source_code
go build main.go


::Posts-------------
::Posts - web server
cd D:\projects\golang_aws_terraform_jenkins\microservices_restful_ec2\posts\source_code
go build main.go


::Products-------------
::Products - web server
cd D:\projects\golang_aws_terraform_jenkins\microservices_restful_ec2\products\source_code
go build main.go

::Invoices-------------
::Invoices - web server
cd D:\projects\golang_aws_terraform_jenkins\microservices_restful_ec2\invoices\source_code
go build main.go

::Build Files :: usermgmt_op1_no_persistence-------------

::usermgmt_client
cd D:\projects\golang_aws_terraform_jenkins\microservices_grpc_ec2\usermgmt_op1_no_persistence\usermgmt_client
go build usermgmt_client.go

::usermgmt_server
cd D:\projects\golang_aws_terraform_jenkins\microservices_grpc_ec2\usermgmt_op1_no_persistence\usermgmt_server
go build usermgmt_server.go


::Build Files :: usermgmt_op2_in_memory-------------

::usermgmt_client
cd D:\projects\golang_aws_terraform_jenkins\microservices_grpc_ec2\usermgmt_op2_in_memory\usermgmt_client
go build usermgmt_client.go

::usermgmt_server
cd D:\projects\golang_aws_terraform_jenkins\microservices_grpc_ec2\usermgmt_op2_in_memory\usermgmt_server
go build usermgmt_server.go


::Build Files :: usermgmt_op3_json_file-------------

::usermgmt_client
cd D:\projects\golang_aws_terraform_jenkins\microservices_grpc_ec2\usermgmt_op3_json_file\usermgmt_client
go build usermgmt_client.go

::usermgmt_server
cd D:\projects\golang_aws_terraform_jenkins\microservices_grpc_ec2\usermgmt_op3_json_file\usermgmt_server
go build usermgmt_server.go

::Build Files :: usermgmt_op4_db_postgres-------------

::usermgmt_client
cd D:\projects\golang_aws_terraform_jenkins\microservices_grpc_ec2\usermgmt_op4_db_postgres\usermgmt_client
go build usermgmt_client.go

::usermgmt_server
cd D:\projects\golang_aws_terraform_jenkins\microservices_grpc_ec2\usermgmt_op4_db_postgres\usermgmt_server
go build usermgmt_server.go

::Build Files :: usermgmt_op5_rest_to_grpc-------------

::usermgmt_client
cd D:\projects\golang_aws_terraform_jenkins\microservices_grpc_ec2\usermgmt_op5_rest_to_grpc\usermgmt_client
go build usermgmt_client.go

::usermgmt_server
cd D:\projects\golang_aws_terraform_jenkins\microservices_grpc_ec2\usermgmt_op5_rest_to_grpc\usermgmt_server
go build usermgmt_server.go
