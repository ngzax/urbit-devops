# These variable MUST be set in your terraform.tfvars file
variable "AWS_ACCESS_KEY" { }
variable "AWS_SECRET_KEY" { }
variable "PATH_TO_PRIVATE_KEY" { }
variable "PRIVATE_KEY_NAME" { }
variable "SECURITY_GROUP_NAME" { }

# These variable can be optionally overridden in your terraform.tfvars file
variable "AWS_AMI_ID" {
  default = "ami-8a7859ef"
}

variable "AWS_INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "AWS_REGION" {
  default = "us-east-2"
}

variable "AWS_USERNAME" {
  default = "ec2-user"
}

variable "URBIT_SHIP_NAME" {
  default = "new-urbit-pier"
}
