output "ec2-public-ip" {
  value = aws_instance.my-ec2.public_ip
}
