###########
#   VPC   #
###########
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  # DNSによる名前解決を有効にしてくれる
  enable_dns_support = true
  # DNSホスト名を自動で割り当ててくれる
  enable_dns_hostnames = true

  tags = {
    # VPCのNameに表示される
    Name = "example"
  }
}

#################
# public subnet #
#################

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.0.0/24"
  # public ipアドレスを自動で割り当ててくれる
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"
}

####################
# internet gateway #
####################

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

####################
#   root table     #
####################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id
}

####################
#     route        #
####################

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}

##############################
# route table association    #
##############################
# 関連付けを忘れた場合defaultのroot tableが使われる
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

##################
# private subnet #
##################

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.example.id
  # cidrを被らないようにする
  cidr_block              = "10.0.64.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

##################
#   nat gateway  #
##################

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  depends_on    = [aws-aws_internet_gateway.example]
}

resource "aws_route" "private" {
  route_table_id = aws_route_table.private.id
  # privateではnat_gateway_idを使用する
  nat_gateway_id         = aws_nat_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}

