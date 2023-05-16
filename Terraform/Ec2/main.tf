# ami
data "aws_ami" "ami-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


#basion host 
resource "aws_instance" "public-ec2" {
  ami                         = data.aws_ami.ami-linux.id
  instance_type               = var.ec2_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.enable_publicIP
  vpc_security_group_ids      = [aws_security_group.ec2-sg.id]
  key_name                    = var.key_name

  tags = {
    Name = var.ec2_name
  }
}

# security group for ec2
resource "aws_security_group" "ec2-sg" {
  name        = var.security_group_ec2
  description = var.security_group_ec2
  vpc_id      = var.vpcID

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public_cidr]
  }

  tags = {
    Name = var.security_group_ec2
  }
}

