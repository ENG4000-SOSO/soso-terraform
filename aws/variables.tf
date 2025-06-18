variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "ec2_key_name" {
  description = "Name of the existing EC2 key pair to use"
  type        = string
}

data "aws_caller_identity" "current" {}
