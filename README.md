
# GCP: Tools to help in Highly Secured Environments.
### IAP tunnelling, private GCP access, and running instances as a service account.

In this Terraform demo we demonstrate several tools that GCP provide that allow us to run highly secured GCP environments with a minimal attack surface area;

1. IAP tunnelling. With this IAP proxy, commonly used for https access to websites, we can also allow access to any port on our cloud instances without needing to either:
    (A) Give our instances with a public IP
    (B) Set up a VPN.
    In this scenario we have given SSH access to a 'bastion' host via IAP, leaving our 'backend' server only accessible from the bastion host. This demo shows how we could secure any number of interfaces and environments, all without requiring those usual methods that require either additional risk (in the case of giving our instance a public IP) or additional overhead and complexity (in the case of VPN)
2. Private Google access. This is a VPC feature that allows us to access the Google cloud via a private network, without any NAT in place, and without any Public IP's on the instances.
3. Running an Instance as a dedicated service account. This is a well known IAM feature that allows our instances to authenticate to GCP services and resources using that accounts credentials. In this case we simply allow the instance to access a storage bucket, but it could be used for any number of applications, including SSH'ing to other instances or accessing other GCP resources.

## Overview Diagram

![alt text](https://github.com/shapleya/tf_gcp_iap_tunnel_ssh_demo/blob/master/images/diagram.png "Overview Diagram")

## Setting it all up using Terraform

Terraform in this case takes care of creating:
- 2 example virtual machine instances, one 'bastion' and one 'backend'
- a Google Cloud storage bucket
- a custom IAM role to give compute admin access to a designated user (anyone with a GCP account could ssh to our bastion)
- an IAM binding to a particular virtual machine instance to allow SSH
- a dedicated service account and IAM binding to allow the bastion host to run as a specific service account
- a custom VPC network
- 2 subnets, one for each instance
- firewall rules to greatly restrict communication to only allow:
    - SSH in to bastion instance via Google IAP, and nowhere else
    - SSH into backend instance from bastion, and nowhere else
    - all instances to only communicate with GCP services, otherwise no outbound internet access (this uses the google TXT record method of retrieving the google netblocks)

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
11. confirm you're using the right project:
> gcloud config set project PROJECT_ID
12. confirm you can browse compute instances:
> gcloud compute instances list
12. confirm you can ssh to the frontend server:
> gcloud beta compute ssh --tunnel-through-iap my-bastion-server
13. confirm from your bastion/frontend server, that you can read the contents of your created storage bucket (the instance authenticates as its service account by default)
> touch example.file
> gsutil cp example.file gs://your-bucket-name
> gsutil ls gs://your-bucket-name
14. confirm you cannot ssh directly to the backend server using the same account:
> gcloud beta compute ssh --tunnel-through-iap my-backend-server


### *References:*

https://cloud.google.com/iap/docs/using-tcp-forwarding

https://cloud.google.com/sdk/gcloud/reference/beta/compute/ssh

https://cloud.google.com/vpc/docs/configure-private-google-access

https://www.terraform.io/docs/providers/google/d/datasource_google_netblock_ip_ranges.html