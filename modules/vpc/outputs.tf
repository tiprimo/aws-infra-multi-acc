output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_arn" {
  value = aws_vpc.this.arn
}

# output "public_subnet_arns" {
#   value = { for s in aws_subnet.public_all_subnets : s.id => s.arn }
# }

# output "private_subnet_arns" {
#   value = { for s in aws_subnet.private_all_subnets : s.id => s.arn }
# }