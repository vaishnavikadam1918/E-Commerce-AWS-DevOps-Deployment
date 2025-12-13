variable "key_name" {}
variable "db_username" {}
variable "db_password" { sensitive = true }
variable "instance_type" { default = "t2.micro" }