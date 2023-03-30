::Compiling binaries to upload to AWS
set GOOS=linux
::ls env:
::set $Env:GOOS=linux

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

::--------Back to root folder-------------
cd D:\projects\golang_aws_terraform_jenkins\

::--------AWS authentication - Dev Environment-------------
set AWS_PROFILE=dev

::--------Terraform - Infrastructure setup-------------

terraform workspace select dev
terraform workspace list
terraform init
terraform validate
terraform plan -var db_password=Suta100* -out "output_plan_dev.tfplan"
terraform apply -auto-approve "output_plan_dev.tfplan"
::--terraform destroy -auto-approve
