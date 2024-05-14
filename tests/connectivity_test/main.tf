resource "aws_security_group" "instance" {
  name        = "connectivity-test-${var.test_name}"
  vpc_id      = var.vpc.id
  description = "Security group for connectivity-test instance"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-arm64"
}

resource "aws_instance" "test_instance" {
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = "t4g.nano"
  subnet_id              = var.subnet.id
  vpc_security_group_ids = [aws_security_group.instance.id]

  instance_initiated_shutdown_behavior = "stop"

  user_data_base64 = base64encode(local.user_data)

  associate_public_ip_address = var.associate_public_ip_address

  tags = {
    Name = "connectivity-test-${var.test_name}"
  }

  lifecycle {
    replace_triggered_by = [aws_security_group.instance]
  }
}

resource "time_sleep" "wait" {
  depends_on = [aws_instance.test_instance]

  triggers = {
    always_wait = timestamp()
  }

  create_duration = "5m"
}

data "aws_instance" "test_instance" {
  instance_id = aws_instance.test_instance.id

  depends_on = [time_sleep.wait]
}

locals {
  user_data = <<EOF
#!/bin/bash

while true
do
  if curl --connect-timeout 5 --fail "${var.url}" -o/dev/null -s -v; then
    shutdown -h now
    exit 0
  fi
done

EOF
}

output "connectivity" {
  value = contains(["stopping", "stopped"], data.aws_instance.test_instance.instance_state)
}
