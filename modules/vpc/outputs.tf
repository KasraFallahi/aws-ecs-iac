output "vpc_id" {
  value = aws_vpc.main_vpc.id
}


output "subnet_ids" {
  value = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}

output "security_group_id" {
  value = [aws_security_group.ecs_security_group.id]
}
