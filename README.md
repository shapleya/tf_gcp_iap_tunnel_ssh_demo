
# GCP: Using IAP tunneling and the "bastion host" that only has an internal IP. No VPN required.

In this Terraform demo we build an example backend server and another 'bastion host' server which we can expose via ssh. The cool part is that neither of these servers has a public ip address.

The trick here is to use GCP's IAP proxy service for authentication, and to use the SSH wrapper Google have built into the gcloud sdk.

For example, we can connect to the example bastion host using the command from any machine that has permission using the new command:
> gcloud beta compute ssh --tunnel-through-iap myservername

This has some useful scenarios for highly secured environments that need to comply with corporate policies as well as making it very convenient and easy to control ssh access into any given GCP environment where public IP's are not desired, or where there may not be a working VPN.

Not covered within this demo are other potential items that could be included in a production build, such as:
- further locking down users to custom roles
- A custom VPC network and subnets
- Firewall rules
- Running a Virtual machine under the context of a service account

# Setting it all up using Terraform

Terraform in this case takes care of creating:
- 2 virtual machine instances
- a custom IAM role to give compute admin access to a designated user
- an IAM binding to a particular virtual machine instance to allow SSH

## prerequisites
- working knowledge of terraform
- a machine to run this from with Terraform installed (v0.12.8 was used)
- google cloud sdk installed
- a GCP project and a GCP service account with sufficient permissions to provision resources using terraform into this project
- IAM and compute API's enabled on the project
- optionally, a GCP bucket for using Terraform remote state

## Initialise
1. download your JSON credentials for the service account with permission to deploy into your project
2. export these credentials:
> export GOOGLE_CREDENTIALS=$(cat /path/to/service_account_credentials.json)
3. clone this repo
4. copy remotestate.tf.example to remotestate.tf and then edit it with your bucket name
5. copy terraform.tfvars.example to terraform.tfvars and then edit it with your project name, desired region, and your test user account (the test account should not have any project access)
6. > terraform init

## Apply

7. > terraform plan
8. > terraform apply

## Test

9. login with your account that previously had no access :
> gcloud auth login
10. use browser to log in
11. confirm you can now see the project and browse compute instances:
> gcloud config set project PROJECT_ID
> gcloud compute instances list
12. confirm you can ssh to the frontend server:
> gcloud beta compute ssh --tunnel-through-iap my-bastion-server
13. confirm you cannot ssh directly to the backend server using the same account:
> gcloud beta compute ssh --tunnel-through-iap my-backend-server


### *References:*

https://cloud.google.com/iap/docs/using-tcp-forwarding

https://cloud.google.com/sdk/gcloud/reference/beta/compute/ssh