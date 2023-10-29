#!/bin/sh
# This is bash program to display Hello World
sudo su
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
chown -R $USER /var/www/html
echo "<h1>Hello World QuantSpark</h1>" > /var/www/html/index.html
