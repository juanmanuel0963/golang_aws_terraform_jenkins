::Compiling binaries to upload to AWS
set GOOS=linux
::ls env:
::set $Env:GOOS=linux

::Build Files :: lambda_func_go-------------
cd D:\projects\golang_aws_terraform_jenkins\microservices_restful_lambda\lambda_func_go\source_code
go build main.go
ren main bootstrap

::Build Files :: Blogs-------------
::Blogs - web server
cd D:\projects\golang_aws_terraform_jenkins\microservices_restful_ec2\blogs\source_code
go build main.go


::Build Files :: Posts-------------
::Posts - web server
cd D:\projects\golang_aws_terraform_jenkins\microservices_restful_ec2\posts\source_code
go build main.go


::Build Files :: Products-------------
::Products - web server
cd D:\projects\golang_aws_terraform_jenkins\microservices_restful_ec2\products\source_code
go build main.go

::Build Files :: Invoices-------------
::Invoices - web server
cd D:\projects\golang_aws_terraform_jenkins\microservices_restful_ec2\invoices\source_code
go build main.go

::Build Files :: Users-------------
::Users - web server
cd D:\projects\golang_aws_terraform_jenkins\microservices_restful_ec2\users\source_code
go build main.go

::Build Files :: Cars-------------
::Users - web server
cd D:\projects\golang_aws_terraform_jenkins\microservices_restful_ec2\cars\source_code
go build main.go

::--------Back to root folder-------------
cd D:\projects\golang_aws_terraform_jenkins\

