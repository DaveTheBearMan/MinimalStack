# Source into the project file
source ./Project-openrc.sh

# Move vars to TF_VAR_
export TF_VAR_openstack_user_name=$OS_USERNAME
export TF_VAR_openstack_password=$OS_PASSWORD
export TF_VAR_tenant_name=$OS_PROJECT_NAME
export TF_VAR_auth_url="https://stack.ritsec.cloud:5000/v3"  # Ensure https

# Alias
alias runtf="terraform init && terraform validate && terraform plan -out plan.tfplan"
alias applytf="terraform apply \"plan.tfplan\""
