::AWS authentication - Dev Environment-------------
set AWS_PROFILE=dev
::ls env:
::--------Terraform - Infrastructure setup-------------
terraform workspace new dev
terraform workspace select dev
terraform workspace list
terraform init
terraform validate
terraform plan -var db_password="Suta100*" -out "output_plan_dev.tfplan"
terraform apply -auto-approve "output_plan_dev.tfplan"
terraform destroy -auto-approve