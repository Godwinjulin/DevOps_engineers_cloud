/// VPC A
resource "aws_vpc" "vapc-A" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  provider             = aws.peer

  tags = {
    Name        = "vpcAx"
    Enviroment  = "dev"
    managedwith = "terraform"
  }
}

/// VPC B
resource "aws_vpc" "vapc-B" {
  cidr_block           = "10.1.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"


  tags = {
    Name        = "vpcBz"
    Enviroment  = "dev"
    managedwith = "terraform"
  }
}
/// public subnet A
resource "aws_subnet" "subnetAx" {
  vpc_id                  = aws_vpc.vapc-A.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1"
  provider                = aws.peer

  tags = {
    Name        = "subnetaz"
    Enviroment  = "dev"
    managedwith = "terraform"
  }
}

/// Private subnet A
resource "aws_subnet" "main-privateA" {
  vpc_id            = aws_vpc.vapc-A.id
  cidr_block        = "10.0.38.0/24"
  availability_zone = "eu-west-1"
  provider          = aws.peer

  tags = {
    Name        = "privatesub"
    Enviroment  = "dev"
    managedwith = "terraform"
  }
}

/// Public subnet B
resource "aws_subnet" "subnetBx" {
  vpc_id                  = aws_vpc.vapc-B.id
  cidr_block              = "10.1.4.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2"


  tags = {
    Name        = "privatesubB"
    Enviroment  = "dev"
    managedwith = "terraform"
  }
}

/// Private subnet B
resource "aws_subnet" "main-privateB" {
  vpc_id            = aws_vpc.vapc-B.id
  cidr_block        = "10.1.29.0/24"
  availability_zone = "eu-west-2"
  
  
  tags = {
    Name        = "subnetP"
    Enviroment  = "dev"
    managedwith = "terraform"
  }
}
/// INTERNET GATEWAY A
resource "aws_internet_gateway" "igw-A1" {
  vpc_id   = aws_vpc.vapc-A.id
  provider = aws.peer

  tags = {
    Name        = "igwAx"
    Enviroment  = "dev"
    managedwith = "terraform"
  }
}

/// INTERNET GATEWAY B
resource "aws_internet_gateway" "igw-B2" {
  vpc_id = aws_vpc.vapc-B.id

  tags = {
    Name        = "igwBz"
    Enviroment  = "dev"
    managedwith = "terraform"
  }
}

/// ROUTE TABLE A 
resource "aws_route_table" "rbtaxx" {
  vpc_id = aws_vpc.vapc-A.id
  provider = aws.peer
  
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = aws_internet_gateway.igw-A1.id

  }

  tags = {
    Name        = "RbtAx"
    Enviroment  = "dev"
    managedwith = "terraform"
  }
}

/// ROUTE TABLE B
resource "aws_route_table" "rbtbzz" {
  vpc_id = aws_vpc.vapc-B.id

  route {
    cidr_block = "10.1.0.0/16"
    gateway_id = aws_internet_gateway.igw-B2.id
  }


  tags = {
    Name        = "RbtBz"
    Enviroment  = "dev"
    managedwith = "terraform"
  }
}

/// PUBLIC ROUTE TABLE ASSSOCIATION A
resource "aws_route_table_association" "Rts-A" {
  subnet_id      = aws_subnet.subnetAx.id
  route_table_id = aws_route_table.rbtaxx.id
  provider       = aws.peer
}

/// PUBLIC ROUTABLE ASSOCIATION B
resource "aws_route_table_association" "Rts-B" {
  gateway_id     = aws_internet_gateway.igw-B2.id
  route_table_id = aws_route_table.rbtbzz.id
}


/// PEERING CONNECTION BETWEEN VPC-1 AND VPC-2
resource "aws_vpc_peering_connection" "connection" {
  peer_owner_id = "3482-5436-8030"
  peer_vpc_id   = aws_vpc.vapc-B.id
  vpc_id        = aws_vpc.vapc-A.id
  provider =      aws.peer
  auto_accept   = false

  tags = {
    Name        = "peeringconnection"
    Enviroment  = "dev"
    managedwith = "terraform"
  }
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.connection.id
  auto_accept               = true

  tags = {
    Side        = "Accepter"
    Enviroment  = "dev"
    managedwith = "terraform"
  }
}