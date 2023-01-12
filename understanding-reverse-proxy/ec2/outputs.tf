output "public_dns" {
  value = aws_instance.web.public_dns
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

output "instance_id" {
  value = aws_instance.web.id 
}