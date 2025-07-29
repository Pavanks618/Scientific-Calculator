provider "aws" {
  region = "us-east-1"
  access_key = "AKIAYHJANLVMFMM2XA5Z"
  secret_key = "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"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  default = "ami-020cba7c55df1f615"
}

variable "key_name" {
  default = "Demo"
}

variable "security_group_id" {
  default = "sg-09fb399e759c7ce8a"
}

variable "bucket_name" {
  default = "my-gating-assessment"
}

resource "aws_instance" "ec2_instances" {
  count         = 2
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "TerraformEC2-${count.index + 1}"
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
  force_destroy = true

  tags = {
    Name = "MyAppBucket"
  }
}

output "ec2_public_ips" {
  value = [for instance in aws_instance.ec2_instances : instance.public_ip]
}
