provider "aws" {
  region = "ap-south-1"
}

# Security Group
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow SSH and Jenkins"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance (Jenkins Server)
resource "aws_instance" "jenkins" {
  ami           = "ami-0f5ee92e2d63afc18" # Amazon Linux 2023 (ap-south-1)
  instance_type = "t3.micro"

  security_groups = [aws_security_group.jenkins_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y

              # Install Java
              yum install java-17-amazon-corretto -y

              # Install Jenkins
              wget -O /etc/yum.repos.d/jenkins.repo \
              https://pkg.jenkins.io/redhat-stable/jenkins.repo

              rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

              yum install jenkins -y

              systemctl enable jenkins
              systemctl start jenkins
              EOF

  tags = {
    Name = "Jenkins-Server"
  }
}
