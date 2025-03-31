sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<h1>Webserver 1</h1>" > /var/www/html/index.html"
