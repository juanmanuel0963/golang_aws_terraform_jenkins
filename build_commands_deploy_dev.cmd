::Compiling binaries to upload to AWS
set GOOS=linux
ls env:
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
go build main.go


::Posts-------------
::Posts - web server
cd D:\projects\golang_aws_terraform_jenkins\microservices_restful_ec2\posts\source_code
del main
del main.exe
go build main.go


::Products-------------
::Products - web server
cd D:\projects\golang_aws_terraform_jenkins\microservices_restful_ec2\products\source_code
del main
del main.exe
go build main.go

::Invoices-------------
::Invoices - web server
cd D:\projects\golang_aws_terraform_jenkins\microservices_restful_ec2\invoices\source_code
del main
del main.exe
go build main.go

::--------Back to root folder-------------
cd D:\projects\golang_aws_terraform_jenkins\

::--------AWS authentication - Dev Environment-------------
set AWS_PROFILE=dev

::--------Terraform - Infrastructure setup-------------

terraform workspace select dev
terraform workspace list
terraform init
terraform validate
terraform plan -out "output_plan_dev.tfplan"
terraform apply -auto-approve "output_plan_dev.tfplan"
::--terraform destroy -auto-approve
