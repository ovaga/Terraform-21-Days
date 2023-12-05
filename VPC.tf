resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main"
  }

}

resource "aws_subnet" "Public1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public1"
  }
}

resource "aws_subnet" "Public2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Public2"
  }
}

resource "aws_subnet" "Private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private1"
  }
}

resource "aws_subnet" "Private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private2"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "Public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }



  tags = {
    Name = "main"
  }
}

resource "aws_route_table_association" "Public1" {
  subnet_id      = aws_subnet.Public1.id
  route_table_id = aws_route_table.Public.id
}

resource "aws_route_table_association" "Public2" {
  subnet_id      = aws_subnet.Public2.id
  route_table_id = aws_route_table.Public.id
}

resource "aws_eip" "nat1" {
  domain = "vpc"
}

resource "aws_eip" "nat2" {
  domain = "vpc"
}

resource "aws_nat_gateway" "main1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.Public1.id

  tags = {
    Name = "main1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}


resource "aws_nat_gateway" "main2" {
  allocation_id = aws_eip.nat2.id
  subnet_id     = aws_subnet.Public2.id

  tags = {
    Name = "main2"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "Private1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main1.id
  }



  tags = {
    Name = "Private1"
  }
}

resource "aws_route_table" "Private2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main2.id
  }



  tags = {
    Name = "Private2"
  }
}

resource "aws_route_table_association" "Private1" {
  subnet_id      = aws_subnet.Private1.id
  route_table_id = aws_route_table.Private1.id
}

resource "aws_route_table_association" "Private2" {
  subnet_id      = aws_subnet.Private2.id
  route_table_id = aws_route_table.Private2.id
}

