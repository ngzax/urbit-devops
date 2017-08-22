provider "aws" {
  shared_credentials_file = "${var.SHARED_CREDENTIALS_FILE}"
  profile                 = "${var.PROFILE}"
  region                  = "${var.AWS_REGION}"
}

resource "aws_security_group" "urbit-sg" {
  name        = "urbit-sg-${var.STATE}"
  description = "Urbit Default Security Group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["158.81.208.0/24", "71.225.91.254/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "urbit-pier" {
  ami               = "${var.AWS_AMI_ID}"
  instance_type     = "${var.AWS_INSTANCE_TYPE}"
  key_name          = "${var.PRIVATE_KEY_NAME}"
  security_groups   = ["${aws_security_group.urbit-sg.name}"]

  tags {
    purpose = "urbit"
  }

  provisioner "file" {
    connection {
      type = "ssh"
      user = "${var.AWS_USERNAME}"
      private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
    }
    source      = "provision-urbit.sh"
    destination = "provision-urbit.sh"
  }

  provisioner "file" {
    connection {
      type = "ssh"
      user = "${var.AWS_USERNAME}"
      private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
    }
    source      = "create-urbit-comet.exp"
    destination = "create-urbit-comet.exp"
  }

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "${var.AWS_USERNAME}"
      private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
    }
    inline = [
      "cd ~",
      "mkdir piers",
      "chmod +x provision-urbit.sh",
      "chmod +x create-urbit-comet.exp",
      "./provision-urbit.sh",
      "./create-urbit-comet.exp"
    ]
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.urbit-pier.id}"

  provisioner "local-exec" {
    command = "rm -f ip_address.txt"
  }

  provisioner "local-exec" {
    command = "echo ${aws_eip.ip.public_ip} > ip_address.txt"
  }
}
