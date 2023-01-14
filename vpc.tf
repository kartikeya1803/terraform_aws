#Creating VPC for our project
resource "aws_vpc" "demo_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "Development"
  }
}

# Creating a public subnet for nginx server
resource "aws_subnet" "nginx_subnet" {
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block              = var.nginx_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "Nginx Subnet"
  }
}

# Creating a private subnet for application server
resource "aws_subnet" "app_subnet" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = var.application_subnet_cidr

  availability_zone = "us-east-1a"
  tags = {
    Name = "Application Subnet"
  }
}

# Creating a private subnet for database server
resource "aws_subnet" "database_subnet" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = var.database_subnet_cidr

  availability_zone = "us-east-1a"
  tags = {
    Name = "Database Subnet"
  }
}

#Creating a internet gateway for internet acess
resource "aws_internet_gateway" "demo_gateway" {
  vpc_id = aws_vpc.demo_vpc.id
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.demo_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_gateway.id
  }
  tags = {
    Name = "Route to internet"
  }
}
# Associating Route Table
resource "aws_route_table_association" "rt1" {
  subnet_id      = aws_subnet.nginx_subnet.id
  route_table_id = aws_route_table.route.id
}


resource "aws_security_group" "nginx_sg" {
  vpc_id = "${aws_vpc.demo_vpc.id}"
# Inbound Rules
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# Outbound Rules
  # Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
    Name = "Nginx SG"
  }
}

resource "aws_security_group" "app_sg" {
  vpc_id = "${aws_vpc.demo_vpc.id}"
# Inbound Rules
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.1.1.0/24"]
  }

# SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.1.1.0/24"]
  }
# Outbound Rules
  # Internet access to anywhere
  
tags = {
    Name = "Application SG"
  }
}