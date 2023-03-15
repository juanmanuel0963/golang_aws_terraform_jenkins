::Compiling binaries to upload to AWS
set GOOS=linux
::ls env:
::set $Env:GOOS=linux
::--------DB migrate--------
cd D:\projects\golang_aws_terraform_jenkins\microservices_restful_ec2\_database\migrate
del migrate
del migrate.exe
go build migrate.go

::Blogs-------------
::Blogs - web server
cd D:\projects\golang_aws_terraform_jenkins\microservices_restful_ec2\blogs\source_code
del main
del main.exe
del *.exe
del *.exe~
go build main.go


::Posts-------------
::Posts - web server
cd D:\projects\golang_aws_terraform_jenkins\microservices_restful_ec2\posts\source_code
del main
del main.exe
del *.exe
del *.exe~
go build main.go


::Products-------------
::Products - web server
cd D:\projects\golang_aws_terraform_jenkins\microservices_restful_ec2\products\source_code
del main
del main.exe
del *.exe
del *.exe~
go build main.go

::Invoices-------------
::Invoices - web server
cd D:\projects\golang_aws_terraform_jenkins\microservices_restful_ec2\invoices\source_code
del main
del main.exe
del *.exe
del *.exe~
go build main.go


::usermgmt_op4_db_postgres-------------

::usermgmt_client
cd D:\projects\golang_aws_terraform_jenkins\microservices_grpc_ec2\usermgmt_op4_db_postgres\usermgmt_client
del usermgmt_client
del usermgmt_client.exe
go build usermgmt_client.go

::usermgmt_server
cd D:\projects\golang_aws_terraform_jenkins\microservices_grpc_ec2\usermgmt_op4_db_postgres\usermgmt_server
del usermgmt_server
del usermgmt_server.exe
del usermgmt_server.exe~
go build usermgmt_server.go

::usermgmt_op5_rest_to_grpc-------------

::usermgmt_client
cd D:\projects\golang_aws_terraform_jenkins\microservices_grpc_ec2\usermgmt_op5_rest_to_grpc\usermgmt_client
del usermgmt_client
del usermgmt_client.exe
go build usermgmt_client.go

::usermgmt_server
cd D:\projects\golang_aws_terraform_jenkins\microservices_grpc_ec2\usermgmt_op5_rest_to_grpc\usermgmt_server
del usermgmt_server
del usermgmt_server.exe
del usermgmt_server.exe~
go build usermgmt_server.go
