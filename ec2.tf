# Creating EC2 instance for nginx server in public subnet
resource "aws_instance" "demoinstance" {
  ami                         = "ami-087c17d1fe0178315"
  instance_type               = "t2.micro"
  count                       = 1
  key_name                    = "nginx"
  vpc_security_group_ids      = ["${aws_security_group.nginx_sg.id}"]
  subnet_id                   = "${aws_subnet.nginx_subnet.id}"
  associate_public_ip_address = true
  user_data                   = "${file("data.sh")}"
tags = {
    Name = "Nginx Server"
  }
}

# Creating  EC2 instance for application server in Private Subnet
resource "aws_instance" "demoinstance1" {
  ami                         = "ami-087c17d1fe0178315"
  instance_type               = "t2.micro"
  count                       = 1
  key_name                    = "tests"
  vpc_security_group_ids      = ["${aws_security_group.app_sg.id}"]
  subnet_id                   = "${aws_subnet.app_subnet.id}"
  associate_public_ip_address = false
  
tags = {
    Name = "Application server"
  }
}


