# Terraform Configuration Generator

Currently includes Dev / QA server only

Install terraform with `brew install terraform`

It includes following resources for now:

- Cloudflare
- Elastic IPs
- Publicly available EC2 instance 
- Relevant security groups for both.

To run, configure your AWS provider as described in 

https://www.terraform.io/docs/providers/aws/index.html

### To generate the configuration run:

```bash
python generate_dev_terraform.py
```
