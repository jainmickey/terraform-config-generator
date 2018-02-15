variable "public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.
Example: ~/.ssh/id_rsa.pub
DESCRIPTION
}

variable "key_name" {
  description = "Desired name of AWS key pair"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "ap-south-1"
}

variable "aws_bucket" {
  description = "AWS Bucket name to create."
  default     = "{% project_name %}-dev"
}

# Ubuntu 16 LTS (x64)
variable "aws_amis" {
  default = {
    ap-south-1 = "ami-099fe766"
  }
}
