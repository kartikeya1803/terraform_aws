variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}
variable "nginx_subnet_cidr" {
  default = "10.1.1.0/24"
}
# Defining CIDR Block for 2nd Subnet
variable "application_subnet_cidr" {
  default = "10.1.2.0/24"
}
# Defining CIDR Block for 3rd Subnet
variable "database_subnet_cidr" {
  default = "10.1.3.0/24"
}
