resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8999
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}

resource "aws_iam_policy" "ec2_backend_policy" {
  name        = "ec2-backend-policy"
  description = "Allow EC2 backend to run ECS tasks and access S3/DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "ECSRunTask",
        Effect = "Allow",
        Action = [
          "ecs:RunTask",
          "ecs:DescribeTasks"
        ],
        Resource = "*"
      },
      {
        Sid    = "AllowPassTaskRole",
        Effect = "Allow",
        Action = "iam:PassRole",
        Resource = aws_iam_role.ecs_task_role.arn
      },
      {
        Sid    = "AllowPassExecRole",
        Effect = "Allow",
        Action = "iam:PassRole",
        Resource = aws_iam_role.ecs_execution_role.arn
      },
      {
        Sid    = "S3Access",
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ],
        Resource = "${aws_s3_bucket.app_bucket.arn}/*"
      },
      {
        Sid    = "DynamoDBAccess",
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query"
        ],
        Resource = aws_dynamodb_table.scheduling_table.arn
      }
    ]
  })
}

resource "aws_iam_role" "ec2_backend_role" {
  name = "ec2-backend-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_backend_attach" {
  role       = aws_iam_role.ec2_backend_role.name
  policy_arn = aws_iam_policy.ec2_backend_policy.arn
}

resource "aws_iam_instance_profile" "ec2_backend_profile" {
  name = "ec2-backend-profile"
  role = aws_iam_role.ec2_backend_role.name
}

resource "aws_instance" "backend" {
  ami                         = "ami-0779caf41f9ba54f0" # Debian AMI
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_backend_profile.name

  tags = {
    Name = "fastapi-backend"
  }
}

output "ec2_public_ip" {
  value = aws_instance.backend.public_ip
}
