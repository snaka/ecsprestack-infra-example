output "id" {
  value = aws_vpc.main.id
}
output "cidr" {
  value = aws_vpc.main.cidr_block
}
output "subnets" {
  value = {
    public  = values(aws_subnet.public)[*].id
    private = values(aws_subnet.private)[*].id
  }
}
