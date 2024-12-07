resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.main_vpc.cidr_block, 8, 1)
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.main_vpc.cidr_block, 8, 2)
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1b"
}
