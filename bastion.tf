resource "aws_instance" "jump-ec2" {
  ami = data.aws_ami.amazon_linux_2023.id
  subnet_id = aws_subnet.public_sub_bastion.id
  key_name = aws_key_pair.terraform-key.key_name
  associate_public_ip_address = true
  security_groups = [aws_security_group.dhiraj-sg.id]
  instance_type = var.instance-type
  iam_instance_profile = aws_iam_instance_profile.ansible.name
  user_data = file("${path.module}/shell-script/bastion.sh")
  depends_on = [ aws_iam_role.ansible_role, aws_autoscaling_group.application_tier, aws_autoscaling_group.presentation_tier]

    connection {
      type        = "ssh"
      user        = "ec2-user" 
      private_key = tls_private_key.pri-terra-key.private_key_pem
      host        = self.public_ip
    }
  provisioner "file" {
    source      = "terraform-key.pem"
    destination = "/home/ec2-user/terraform-key.pem" 
  }
  provisioner "file" {
    source      = "${path.module}/shell-script/get-hosts.sh"
    destination = "/home/ec2-user/get-hosts.sh"
   
  }
  provisioner "file" {
    source      = "${path.module}/shell-script/get-hosts-web.sh"
    destination = "/home/ec2-user/get-hosts-web.sh"
  }
  provisioner "file" {
    source      = "${path.module}/shell-script/get-lb-dns.sh"
    destination = "/home/ec2-user/get-lb-dns.sh"
  }
  provisioner "file" {
    source      = "${path.module}/shell-script/get-db-dns.sh"
    destination = "/home/ec2-user/get-db-dns.sh"
  }
  provisioner "remote-exec" {
    inline = [
      # "mv /tmp/ssh-key-2024-02-19.key /home/ec2-user/terraform-key.pem",
      "chmod 400 /home/ec2-user/terraform-key.pem",
      "chmod +x /home/ec2-user/get-hosts.sh",
      "chmod +x /home/ec2-user/get-hosts-web.sh",
      "chmod +x /home/ec2-user/get-db-dns.sh",
      "chmod +x /home/ec2-user/get-lb-dns.sh",
      "mkdir /home/ec2-user/playbooks",
      "echo 'Provisioner script completed' > /home/ec2-user/provisioner_done.txt"
    ]
  }
    provisioner "file" {
    source      = "${path.module}/shell-script/playbooks/react.yml"
    destination = "/home/ec2-user/playbooks/react.yml"
  }
    provisioner "file" {
    source      = "${path.module}/shell-script/playbooks/spring.yml"
    destination = "/home/ec2-user/playbooks/spring.yml"
  }

  tags = {
    Name = "Bastion-Host"
  }

}
