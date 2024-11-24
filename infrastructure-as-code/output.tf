output "eip_ariane_public_ip" {
  value = aws_eip.technical_test_ariane_eip.public_ip
}

output "ec2_ariane_private_ip" {
  value =  aws_instance.technical-test-ariane.private_ip
}

output "ec2_falcon_private_ip" {
  value = aws_instance.technical-test-falcon.private_ip
}

output "ec2_redis_private_ip" {
  value = aws_instance.technical-test-redis.private_ip
}
