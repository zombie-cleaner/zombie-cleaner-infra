# EC2 instance outputs =======================================================================

output "instance_id" {
  description = "ID of the Spring Boot EC2 instance"
  value       = aws_instance.springboot.id
}

output "instance_arn" {
  description = "ARN of the Spring Boot EC2 instance"
  value       = aws_instance.springboot.arn
}

output "public_ip" {
  description = "Public IP address of the Spring Boot EC2 instance"
  value       = aws_eip.springboot.public_ip
}

output "public_dns" {
  description = "Public DNS of the Spring Boot EC2 instance"
  value       = aws_eip.springboot.public_dns
}

output "security_group_id" {
  description = "ID of the security group attached to the Spring Boot EC2 instance"
  value       = aws_security_group.springboot_sg.id
}

output "instance_availability_zone" {
  description = "Availability zone of the instance"
  value       = aws_instance.springboot.availability_zone
}
