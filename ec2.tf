# Creating EC2 instance for nginx server in public subnet
resource "aws_instance" "nginx_server" {
  ami                         = "ami-087c17d1fe0178315"
  instance_type               = "t2.micro"
  count                       = 1
  key_name                    = "nginx-key"
  vpc_security_group_ids      = ["${aws_security_group.nginx_sg.id}"]
  subnet_id                   = aws_subnet.nginx_subnet.id
  associate_public_ip_address = true
  user_data                   = file("setup_nginx.sh")
  tags = {
    Name = "Nginx Server"
  }
}

# Creating  EC2 instance for application server in Private Subnet
resource "aws_instance" "app_server" {
  ami                         = "ami-087c17d1fe0178315"
  instance_type               = "t2.micro"
  count                       = 1
  key_name                    = "app-key"
  vpc_security_group_ids      = ["${aws_security_group.app_sg.id}"]
  subnet_id                   = aws_subnet.app_subnet.id
  associate_public_ip_address = false
   user_data                   = file("setup_apache.sh")

  tags = {
    Name = "Application server"
  }
}

# Creating a Postgres database in subnet group
resource "aws_db_instance" "postgres_db" {
  
  db_name                = "sampledb"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  skip_final_snapshot    = true
  
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  username               = "kmittal"
  password               = "admin123"
  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.name
}

