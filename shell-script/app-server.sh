#!/bin/bash
sudo yum update -y && sudo yum upgrade -y
sudo yum install java-17-amazon-corretto-devel -y
sudo yum install git -y
git clone https://github.com/devDhiraj12/jar-files.git /home/ec2-user/jars 
nohup java -jar /home/ec2-user/jars/spring.jar > /dev/null 2>&1 & 
 