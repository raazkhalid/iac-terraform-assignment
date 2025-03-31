output "instance1_public_ip" {
  description = "Public IP of the EC2 Instance 1 webserver"
  value       = aws_instance.webserver_1.public_ip
}

output "instance2_public_ip" {
  description = "Public IP of the EC2 Instance 2 webserver"
  value       = aws_instance.webserver_2.public_ip
}

output "rds_endpoint" {
  description = "Endpoint of the RDS DB instance"
  value       = aws_db_instance.mysql_db.endpoint
}