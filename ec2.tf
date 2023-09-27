/// AWS INSTANCE B
resource "aws_instance" "terraform_ec2A" {
  ami                         = " ami-0bf84c42e04519c85"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.terraec2_securityA.id}"]
  subnet_id                   = aws_subnet.subnetAx.id
  key_name                    = "IRELAND-KEY.pem"
  associate_public_ip_address = true
  provider                    = aws.peer

  tags = {
    Name        = "myec2Ax"
    Enviroment  = "dev"
    managedwith = "terraform"
  }
}

/// AWS INSTANCE A
resource "aws_instance" "terraform_ec2B" {
  ami                         = "ami-09d5dd12541e69077 "
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.terraec2_securityB.id}"]
  subnet_id                   = aws_subnet.subnetBx.id
  key_name                    = "LONDON-KEY.pem"
  associate_public_ip_address = true


  tags = {
    Name        = "myec2Bx"
    Enviroment  = "dev"
    managedwith = "terraform"
  }
}