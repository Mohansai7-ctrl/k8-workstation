resource "aws_instance" "k8_workstation" {
    ami = data.aws_ami.ami_info.id
    instance_type = "t3.micro"
    #while creating workstation required are instance_type is t3.micro but additional storage should be 50 GBi
    # #instance_market_options {
    #     market_type = "spot"
    #     spot_options {
    #         market_price = 0.031
    #     }
    # }
    #associate_public_ip_address = true
    root_block_device {
        volume_size = 50
    }

    vpc_security_group_ids = ["sg-0d91387712ba38962"]

    

    tags = {
        Name = "k8.workstation"
    }
}

resource "null_resource" "k8" {
    triggers = {
        instance_id = aws_instance.k8_workstation.id

    }

    
    connection {
        type = "ssh"
        host = aws_instance.k8_workstation.public_ip
        user = "ec2-user"
        password = "DevOps321"
    }

    provisioner "file" {
        source = "scripts.sh"
        destination = "/tmp/scripts.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/scripts.sh",
            "sudo sh /tmp/scripts.sh"
        ]

    }
}