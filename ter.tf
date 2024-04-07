provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "main1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet1_cidr

  tags = {
    Name = var.subnet1_name
  }
}

resource "aws_subnet" "main2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet2_cidr

  tags = {
    Name = var.subnet2_name
  }
}

resource "aws_subnet" "main3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet3_cidr

  tags = {
    Name = var.subnet3_name
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.rt_cidr
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "example"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main1.id
  route_table_id = aws_route_table.route.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.main2.id
  route_table_id = aws_route_table.route.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.main3.id
  route_table_id = aws_route_table.route.id
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = file("/home/ec2-user/.ssh/id_rsa.pub")
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_type
  availability_zone = var.az
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name = aws_key_pair.deployer.key_name
  count = 1
  user_data = file(var.userdata)
  tags = {
    Name = var.ec2_name
  }
}

resource "null_resource" "install_nagios" {

  # Connection details for SSH
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa") # Use the private key here
    host        = aws_instance.web.public_ip
  }
}
