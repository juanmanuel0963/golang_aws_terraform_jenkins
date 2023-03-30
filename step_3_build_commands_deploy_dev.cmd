::Compiling binaries to upload to AWS
set GOOS=linux
::ls env:
::set $Env:GOOS=linux

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
