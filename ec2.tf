resource "aws_instance" "app" {
ami = "ami-03695d52f0d883f65"
instance_type = var.instance_type
key_name = var.key_name
security_groups = [aws_security_group.ec2_sg.name]


user_data = <<EOF
#!/bin/bash
yum update -y
yum install java-17-amazon-corretto git -y
mkdir /opt/app
EOF
}