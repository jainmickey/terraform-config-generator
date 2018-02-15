# Terraform Configuration for Dev and QA server

Install teraform with `brew install terraform`

It includes following resources for now:

- Cloudflare
- Elastic IPs
- Publicly available EC2 instance 
- Relevant security groups for both.

To run, configure your AWS provider as described in 

https://www.terraform.io/docs/providers/aws/index.html

Run with a command like this:

```
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export CLOUDFLARE_EMAIL=""
export CLOUDFLARE_TOKEN=""

terraform init
terraform plan
terraform apply

terraform destroy
```
