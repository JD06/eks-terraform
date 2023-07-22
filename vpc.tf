data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = local.common_tags
}

resource "aws_subnet" "private" {
  count = var.az_count
  vpc_id = aws_vpc.this.id
  cidr_block = cidrsubnet(var.cidr_block, 4, count.index + var.az_count)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = local.common_tags
}

resource "aws_subnet" "public" {
  count = var.az_count
  vpc_id = aws_vpc.this.id
  cidr_block = cidrsubnet(var.cidr_block, 4, count.index + var.az_count)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = local.common_tags
}

resource "aws_internet_gateway" "igw" {
  depends_on = [aws_vpc.this]
  vpc_id = aws_vpc.this.id

  tags = local.common_tags
}

resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public[0].id
  tags = local.common_tags
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project}-public-route"

  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.project}-private-route"
  }
}

resource "aws_route_table_association" "public" {
  count = var.az_count
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = var.az_count
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}