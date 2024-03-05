#!/bin/bash
sudo yum update -y && sudo yum upgrade -y
sudo yum install -y nodejs npm
sudo yum install git -y
# git clone https://github.com/devDhiraj12/jar-files.git /home/ec2-user/jars
npm install pm2 -g
npm install -g serve
pm2 serve /home/ec2-user/jars/build 3001 --spa    