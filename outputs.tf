output "public_ip" {
    description = "Public IP of created k8-workstation instance"
    value = aws_instance.k8_workstation.public_ip
}