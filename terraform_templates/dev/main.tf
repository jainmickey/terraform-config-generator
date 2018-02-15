provider "aws" {
  region = "${var.aws_region}"
}

# Configure the Cloudflare provider
provider "cloudflare" {
  # email = "${var.cloudflare_email}"
  # token = "${var.cloudflare_token}"
}

# Elastic IP Resource
# =========================================================
resource "aws_eip" "dev" {
  vpc      = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.web.id}"
  allocation_id = "${aws_eip.dev.id}"
}

# Cloudflare Resource
# =========================================================
# Create a record for dev instance IP
resource "cloudflare_record" "{% project_name %}-dev" {
  domain = "fueled.engineering"
  name   = "backend.{% project_name %}-dev"
  value  = "${aws_eip.dev.public_ip}"
  type   = "A"
  # ttl    = 3600
}

# Create a record for QA instance IP
resource "cloudflare_record" "{% project_name %}-qa" {
  domain = "fueled.engineering"
  name   = "backend.{% project_name %}-qa"
  value  = "${aws_eip.dev.public_ip}"
  type   = "A"
  # ttl    = 3600
}

# EC2 Resource
# =========================================================
resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "{% project_name %}_web"
  description = "created by terraform"
  # vpc_id      = "${aws_vpc.default.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "web" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    user = "ubuntu"

    # The connection will use the local SSH agent for authentication.
  }

  instance_type = "t2.micro"

  root_block_device = {
    volume_type = "gp2"
    volume_size = "20"
  }

  ebs_block_device = {
    device_name = "/dev/sdf"
    volume_type = "gp2"
    volume_size = "30"
    # delete_on_termination = false # <<<< !!!IMPORTANT!!!
  }

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.aws_amis, var.aws_region)}"

  # The name of our SSH keypair we created above.
  key_name = "${aws_key_pair.auth.id}"

  # Our Security group to allow HTTP and SSH access
  security_groups = ["${aws_security_group.default.name}"]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  # subnet_id = "${aws_subnet.default.id}"

  monitoring = true

  tags {
    Name = "{% project_name %} dev/qa"
  }

  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install python aptitude which is used by ansible.
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install python-apt aptitude",
    ]
  }
}

# S3 Resource
# =========================================================
# resource "aws_s3_bucket" "dev" {
#   bucket = "${var.aws_bucket}"
#   acl    = "public-read"
# }
