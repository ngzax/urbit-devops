# ---
# These variable MUST be set in your terraform.tfvars file
# ---
variable "PATH_TO_PRIVATE_KEY" { }
variable "PRIVATE_KEY_NAME" { }
variable "SHARED_CREDENTIALS_FILE" { }

# ---
# These variable can be optionally overridden in your terraform.tfvars file
# ---
variable "ALLOW_SSH_FROM_IPS" {
  type = "list"
  default = ["0.0.0.0/0", "0.0.0.0/0"]
}

variable "ALLOW_SSH_FROM_IP_2" {
  default = "0.0.0.0/0"
}

variable "AWS_AMI_ID" {
  default = "ami-06e54d05255faf8f6"
}

variable "AWS_INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "AWS_REGION" {
  default = "us-west-2"
}

variable "AWS_USERNAME" {
  default = "ubuntu"
}

variable "PROFILE" {
  default = "default"
}

variable "STATE" {
  default = "oregon"
}

variable "URBIT_SHIP_NAME" {
  default = "new-urbit-pier"
}
