output "vpc_id" {
  value = aws_vpc.dhiraj-vpc.id
}
output "instance_ip" {
  value = aws_instance.jump-ec2.public_ip
  description = "The public IP of the instance"
}
output "alb_dns_name_web" {
    value = "DNS name of the web_server Load Balancer ${aws_lb.front_end.dns_name}"
}
output "alb_dns_name_app" {
    value = "DNS name of the Applicaton Load Balancer ${aws_lb.application_tier.dns_name}"
}
  