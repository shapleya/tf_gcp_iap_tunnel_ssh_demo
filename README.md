
# GCP: Using IAP tunneling and the "bastion host" that only has an internal IP. No VPN required.

In this Terraform demo we build an example "backend" server which in this example may hold some sensitive data, and another "bastion" server which we can expose via ssh.

Neither of these servers has a public ip address, but one of them can be accessed over the internet via secure IAP proxy once a designated role has been created and assigned. 

The only difference between these hosts is that the "bastion host", while not exposed to the internet, or even having a public ip address, can be still connected to via SSH, from your desktop using GCP's IAP proxy service and an SSH wrapper. 

We can connect to the example bastion host using the command from any machine that has permission using the new command
> gcloud beta compute ssh --tunnel-through-iap myservername

This has some useful scenarios for highly secured environments that need to comply with corporate policies as well as making it very convenient and easy to control ssh access into any given GCP environment where public IP's are not desired, or where there may not be a working VPN.

Not covered within this demo are other potential items that could be included in a production build, such as:
- further locking down users to custom roles
- A custom VPC network and subnets
- Firewall rules
- Running a Virtual machine under the context of a service account

# Setting it all up using Terraform

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