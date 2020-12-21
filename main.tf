terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.22.0"
    }
  }
}

provider "aws" {
    region = "us-east-2"
}

resource "aws_instance" "example_ec2" {
    ami = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"

    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World" > index.html
                nohup busybox httpd -f -p "${var.server_port}" &
                EOF

    vpc_security_group_ids = [aws_security_group.asg_ec2_example.id]

    tags = {
        Name = "my_ec2_example"
    }
}

resource "aws_security_group" "asg_ec2_example" {
    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

variable "server_port" {
    description = "HTTP requests port"
    type = number
    default = 8080
}

output "public_ip" {
    value = aws_instance.example_ec2.public_ip
    description = "Public server IP"
}



resource "aws_api_gateway_rest_api" "MyDemoAPI" {
  name        = "MyDemoAPI"
  description = "This is my API for demonstration purposes"
}


resource "aws_dynamodb_table" "my-dynamodb-table" {
  name           = "GameScores_AbsolutelyNoPlagiarism"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserId"
  range_key      = "GameTitle"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "GameTitle"
    type = "S"
  }

  attribute {
    name = "TopScore"
    type = "N"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  global_secondary_index {
    name               = "GameTitleIndex"
    hash_key           = "GameTitle"
    range_key          = "TopScore"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["UserId"]
  }

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}






