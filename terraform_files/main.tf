provider "aws" {
  region = "us-east-1"
  profile = "default"
  shared_credentials_file = "/root/.aws/credentials"
}

resource "aws_instance" "k8-health-server" {
  ami                    = "ami-0bbdd8c17ed981ef9"
  instance_type          = "t3.medium"
  vpc_security_group_ids = ["sg-00fc35b46c299fc5b"]
  key_name               = "sir"

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  tags = {
    Name = "k8-health-server"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install docker.io -y",
      "sudo systemctl start docker",
      "sudo wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64",
      "sudo chmod +x /home/ubuntu/minikube-linux-amd64",
      "sudo cp minikube-linux-amd64 /usr/local/bin/minikube",
      "curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl",
      "sudo chmod +x /home/ubuntu/kubectl",
      "sudo cp kubectl /usr/local/bin/kubectl",
      "sudo group docker",
      "sudo usermod -aG docker ubuntu"
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("./bank.pem")
    }
  }
}
