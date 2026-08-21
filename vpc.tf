resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.virginia_cidr
  tags = {
    Name = "vpc_virginia-${local.sufix}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc_virginia.id
  # cidr_block              = var.public_subnet
  cidr_block = var.subnets[0]

  map_public_ip_on_launch = true // Asigna direcciones ip publicas

  tags = {
    Name = "Public Subnet-${local.sufix}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc_virginia.id
  # cidr_block = var.private_subnet
  cidr_block = var.subnets[1]

  tags = {
    Name = "Private Subnet-${local.sufix}"
  }

  // It's not necesary because terraform in this case knows dependency
  depends_on = [
    aws_subnet.public_subnet
  ]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_virginia.id

  tags = {
    Name = "igw vpc virginia-${local.sufix}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_virginia.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  # route {
  #   ipv6_cidr_block        = "::/0"
  #   egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
  # }

  tags = {
    Name = "public custom route table-${local.sufix}"
  }
}

resource "aws_route_table_association" "crta_public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_vpc" "mainvpc" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_security_group" "sg_public_instance" {
  name        = "Public Instance SG"
  description = "Security group for public instance"
  vpc_id      = aws_vpc.vpc_virginia.id

  # ingress {
  #   description = "Allow SSH inbound traffic"
  #   protocol    = "tcp"
  #   from_port   = 22
  #   to_port     = 22
  #   self        = true
  #   cidr_blocks = [var.sg_ingress_cidr]
  # }
  # ingress {
  #   description = "Allow httpd inbound traffic"
  #   protocol    = "tcp"
  #   from_port   = 80
  #   to_port     = 80
  #   self        = true
  #   cidr_blocks = [var.sg_ingress_cidr]
  # }

dynamic "ingress" {
    for_each = var.ingress_ports_list
    content {
      description = "Allow inbound traffic on port ${ingress.value}"
      protocol    = "tcp"
      from_port   = ingress.value
      to_port     = ingress.value
      cidr_blocks = [var.sg_ingress_cidr]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public instance sg-${local.sufix}"
  }
}