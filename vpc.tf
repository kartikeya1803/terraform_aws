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
  cidr_block             = var.nginx_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "Nginx Subnet"
  }
}

# Creating a private subnet for application server
resource "aws_subnet" "app_subnet" {
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block             = var.application_subnet_cidr
  
  availability_zone = "us-east-1a"
tags = {
    Name = "Application Subnet"
  }
}

# Creating a private subnet for database server
resource "aws_subnet" "database_subnet" {
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block             = var.database_subnet_cidr
  
  availability_zone = "us-east-1a"
tags = {
    Name = "Database Subnet"
  }
}

#Creating a internet gateway for internet acess
resource "aws_internet_gateway" "demo_gateway" {
  vpc_id = "${aws_vpc.demo_vpc.id}"
}

resource "aws_route_table" "route" {
    vpc_id = "${aws_vpc.demo_vpc.id}"
route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.demo_gateway.id}"
    }
tags = {
        Name = "Route to internet"
    }
}
# Associating Route Table
resource "aws_route_table_association" "rt1" {
    subnet_id = "${aws_subnet.nginx_subnet.id}"
    route_table_id = "${aws_route_table.route.id}"
}
