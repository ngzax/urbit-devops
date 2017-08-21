provider "aws" {
  shared_credentials_file = "${var.SHARED_CREDENTIALS_FILE}"
  profile                 = "${var.PROFILE}"
  region                  = "${var.AWS_REGION}"
}

resource "aws_instance" "urbit-pier" {
  ami               = "${var.AWS_AMI_ID}"
  instance_type     = "${var.AWS_INSTANCE_TYPE}"
  key_name          = "${var.PRIVATE_KEY_NAME}"
  security_groups   = ["${var.SECURITY_GROUP_NAME}"]

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
