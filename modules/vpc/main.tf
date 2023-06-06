#Criação de VPC principal
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = var.tags
}

#Criação de Internet Gateway que servirá todas as subnets publicas
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

#Criação de todas as subnets publicas atraves de uma variavel map e foreach
resource "aws_subnet" "public_all_subnets" {
  for_each   = var.public_subnets
  vpc_id     = aws_vpc.this.id
  cidr_block = each.value.cidr_block
  tags = var.tags
}

#Criação de todas as subnets privadas atraves de uma variavel map e foreach
resource "aws_subnet" "private_all_subnets" {
  for_each   = var.private_subnets
  vpc_id     = aws_vpc.this.id
  cidr_block = each.value.cidr_block
  tags = var.tags
}

#Criação de uma route table para as subnets publicas que apontaram o trafego para internet para um internet gateway
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

#Criação da route table para as subnets privadas
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name = "Private Route Table"
  }
}

#Associa a route table publica a todas as subnets publicas
resource "aws_route_table_association" "public_rt_ass" {
  for_each        = aws_subnet.public_all_subnets
  subnet_id       = each.value.id
  route_table_id  = aws_route_table.public_route_table.id
}

#Associa a route table privada a todas as subnets privadas
resource "aws_route_table_association" "private_rt_ass" {
  for_each       = aws_subnet.private_all_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_table.id
}

#Criação de um natgateway que sera a saida de internet das subnets privadas e que utilizar o internet gateway como destino
resource "aws_nat_gateway" "this" {
  allocation_id   = aws_eip.this.id
  subnet_id       = aws_subnet.public_all_subnets[element(keys(var.public_subnets), 0)].id

  tags = {
    Name = "NAT Gateway"
  }
}

#Criação de um Elastic IP para o NAT Gateway
resource "aws_eip" "this" {
  vpc = true

  tags = {
    Name = "NAT Gateway Elastic IP"
  }
}


#Resource Access Manager para compartilhar as subnets com contas filho
resource "aws_ram_resource_share" "this" {
  name                      = var.ram_name
  allow_external_principals = false
}

resource "aws_ram_principal_association" "example" {
  for_each = toset(var.account_ids)
  principal          = each.key
  resource_share_arn = aws_ram_resource_share.this.arn
}

resource "aws_ram_resource_association" "public_subnets_ass" {
  for_each = var.public_subnets

  resource_arn       = aws_subnet.public_all_subnets[each.key].arn
  resource_share_arn = aws_ram_resource_share.this.arn
}

resource "aws_ram_resource_association" "private_subnets_ass" {
  for_each = var.private_subnets

  resource_arn       = aws_subnet.private_all_subnets[each.key].arn
  resource_share_arn = aws_ram_resource_share.this.arn
}