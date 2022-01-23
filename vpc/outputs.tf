output "VPC_ID" {
  value = aws_vpc.main.id
}

output "DEFAULT_VPC_ID" {
  value = var.DEFAULT_VPC_ID
}

output "PRIVATE_SUBNETS_IDS" {
  value = aws_subnet.private_subnets.*.id
}

output "PUBLIC_SUBNETS_IDS" {
  value = aws_subnet.public_subnets.*.id
}

output "PRIVATE_SUBNETS_CIDR" {
  value = aws_subnet.public_subnets.*.cidr_block
}

output "PUBLIC_SUBNETS_CIDR" {
  value = aws_subnet.public_subnets.*.cidr_block
}

output "DEFAULT_VPC_CIDR" {
  value = var.DEFAULT_VPC_CIDR
}

output "INTERNAL_HOSTEDZONE_ID" {
  value = var.INTERNAL_HOSTEDZONE_ID
}

output "ALL_VPC_CIDR" {
  value = local.ALL_VPC_CIDR
}

output "PUBLIC_HOSTEDZONE_ID" {
  value = var.PUBLIC_HOSTEDZONE_ID
}