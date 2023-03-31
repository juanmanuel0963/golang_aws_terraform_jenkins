::AWS authentication - Tools Environment-------------
set AWS_PROFILE=tools
::ls env:
::--------Terraform - Infrastructure setup-------------

terraform workspace select tools
terraform workspace list
terraform init
terraform validate
terraform plan -var db_password=Suta100* -out "output_plan_tools.tfplan"
terraform apply -auto-approve "output_plan_tools.tfplan"
::--terraform destroy -auto-approve