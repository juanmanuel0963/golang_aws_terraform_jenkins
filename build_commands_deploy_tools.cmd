::AWS authentication - Tools Environment-------------
set AWS_PROFILE=tools

terraform workspace select tools
terraform workspace list
terraform init
terraform validate
terraform plan -out "output_plan_tools.tfplan"
terraform apply -auto-approve "output_plan_tools.tfplan"
::--terraform destroy -auto-approve