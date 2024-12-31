# Source into the project file
source ./Project-openrc.sh

# Move vars to TF_VAR_
export TF_VAR_openstack_user_name=$OS_USERNAME
export TF_VAR_openstack_password=$OS_PASSWORD
export TF_VAR_tenant_name=$OS_PROJECT_NAME
export TF_VAR_auth_url=$OS_AUTH_URL
