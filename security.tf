resource "aws_security_group" "ec2_sg" {
name = "ec2-sg"


ingress {
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}


ingress {
from_port = 8080
to_port = 8080
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
}


resource "aws_security_group" "rds_sg" {
name = "rds-sg"


ingress {
from_port = 3306
to_port = 3306
protocol = "tcp"
security_groups = [aws_security_group.ec2_sg.id]
}
}