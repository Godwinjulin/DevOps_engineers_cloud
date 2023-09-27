/// security group A
resource "aws_security_group" "terraec2_securityA" {
  name        = "ec2_security"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vapc-A.id
  provider    = aws.peer


  ingress {
    description = "Inbound rules from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vapc-A.cidr_block]

  }

  ingress {
    description = "Inbound rule from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vapc-A.cidr_block]
  }
  ingress {
    description = "Inbound rules from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vapc-A.cidr_block]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name        = "vpc1"
    Enviroment  = "dev"
    managedwith = "terraform"
  }
}

/// security group B
resource "aws_security_group" "terraec2_securityB" {
  name        = "ec2_security"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vapc-B.id

  ingress {
    description = "Inbound rules from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vapc-A.cidr_block]

  }

  ingress {
    description = "Inbound rule from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vapc-A.cidr_block]
  }
  ingress {
    description = "Inbound rules from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vapc-A.cidr_block]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name        = "vpc2"
    Enviroment  = "dev"
    managedwith = "terraform"
  }
}