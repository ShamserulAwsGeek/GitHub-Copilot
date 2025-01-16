provider "aws" {
    region = "us-west-2"
}

resource "aws_fsx_ontap_file_system" "example" {
    storage_capacity = 2048
    subnet_ids       = ["subnet-12345678"]
    throughput_capacity = 256
    deployment_type = "MULTI_AZ_1"
    preferred_subnet_id = "subnet-12345678"
    route_table_ids = ["rtb-12345678"]

    disk_iops_configuration {
        mode = "AUTOMATIC"
    }

    timeouts {
        create = "30m"
        delete = "30m"
    }
}

resource "aws_fsx_ontap_storage_virtual_machine" "example" {
    file_system_id = aws_fsx_ontap_file_system.example.id
    name           = "svm-example"
    subnet_ids     = ["subnet-12345678"]
}

resource "aws_fsx_ontap_volume" "example" {
    storage_virtual_machine_id = aws_fsx_ontap_storage_virtual_machine.example.id
    name                       = "volume-example"
    size_in_megabytes          = 1024
    junction_path              = "/example"
    security_style             = "NTFS"
}

resource "aws_fsx_ontap_volume_export_policy" "example" {
    volume_id = aws_fsx_ontap_volume.example.id

    rule {
        allowed_clients = ["0.0.0.0/0"]
        cifs {
            read_only = false
        }
    }
}

resource "aws_security_group" "example" {
    name        = "fsx-ontap-sg"
    description = "Allow CIFS traffic"
    vpc_id      = "vpc-12345678"

    ingress {
        from_port   = 445
        to_port     = 445
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "windows_server" {
    ami           = "ami-0abcdef1234567890"
    instance_type = "t2.medium"
    subnet_id     = "subnet-12345678"
    security_groups = [aws_security_group.example.name]

    user_data = <<-EOF
                            <powershell>
                            $fsx_dns_name = "${aws_fsx_ontap_storage_virtual_machine.example.dns_name}"
                            $volume_path = "${aws_fsx_ontap_volume.example.junction_path}"
                            New-PSDrive -Name "Z" -PSProvider FileSystem -Root "\\\$fsx_dns_name\$volume_path" -Persist
                            </powershell>
                            EOF

    tags = {
        Name = "WindowsServer"
    }
}

#New code for fsx ontap


variable "region" {
  default = "us-west-2"
}

variable "subnet_id" {
  default = "subnet-12345678"
}

variable "route_table_id" {
  default = "rtb-12345678"
}

variable "vpc_id" {
  default = "vpc-12345678"
}

variable "ami_id" {
  default = "ami-0abcdef1234567890"
}

provider "aws" {
  region = var.region
}

resource "aws_fsx_ontap_file_system" "example" {
  storage_capacity   = 2048
  throughput_capacity = 256
  deployment_type    = "MULTI_AZ_1"
  subnet_ids         = [var.subnet_id]
  preferred_subnet_id = var.subnet_id
  route_table_ids    = [var.route_table_id]

  disk_iops_configuration {
    mode = "AUTOMATIC"
  }

  timeouts {
    create = "30m"
    delete = "30m"
  }
}

resource "aws_fsx_ontap_storage_virtual_machine" "example" {
  file_system_id = aws_fsx_ontap_file_system.example.id
  name           = "svm-example"
  subnet_ids     = [var.subnet_id]
}

resource "aws_fsx_ontap_volume" "example" {
  storage_virtual_machine_id = aws_fsx_ontap_storage_virtual_machine.example.id
  name                       = "volume-example"
  size_in_megabytes          = 1024
  junction_path              = "/example"
  security_style             = "NTFS"
}

resource "aws_fsx_ontap_volume_export_policy" "example" {
  volume_id = aws_fsx_ontap_volume.example.id

  rule {
    allowed_clients = ["0.0.0.0/0"]
    cifs {
      read_only = false
    }
  }
}

resource "aws_security_group" "example" {
  name        = "fsx-ontap-sg"
  description = "Allow CIFS traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 445
    to_port     = 445
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "windows_server" {
  ami           = var.ami_id
  instance_type = "t2.medium"
  subnet_id     = var.subnet_id
  security_groups = [aws_security_group.example.name]

  user_data = <<-EOF
                          <powershell>
                          $fsx_dns_name = "${aws_fsx_ontap_storage_virtual_machine.example.dns_name}"
                          $volume_path = "${aws_fsx_ontap_volume.example.junction_path}"
                          New-PSDrive -Name "Z" -PSProvider FileSystem -Root "\\\$fsx_dns_name\$volume_path" -Persist
                          </powershell>
                          EOF

  tags = {
    Name = "WindowsServer"
  }
}
