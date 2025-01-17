provider "aws" {
  region = "us-east-1"
}

# ECR Repository
resource "aws_ecr_repository" "my_repo" {
  name = "backend"
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRoleNew"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}

# ECS Cluster
resource "aws_ecs_cluster" "my_cluster" {
  name = "my-ecs-cluster"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "my_task" {
  family                   = "my-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name      = "my-container"
      image     = "${aws_ecr_repository.my_repo.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = ["subnet-0270f905ad580e53c","subnet-0b97eefecf821689e","subnet-0571de9dba3eac6d3"]
    security_groups  = ["sg-0a4ecf499a9d40c07"]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.my_target_group.arn
    container_name   = "my-container"
    container_port   = 80
  }
  depends_on = [aws_lb_listener.my_listener]
}

# Load Balancer
resource "aws_lb" "my_lb" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-0a4ecf499a9d40c07"]
  subnets            = ["subnet-0270f905ad580e53c","subnet-0b97eefecf821689e","subnet-0571de9dba3eac6d3"]
}

# Load Balancer Target Group
resource "aws_lb_target_group" "my_target_group" {
  name        = "my-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "vpc-01cad105676811574" # Update with your VPC ID
  target_type = "ip"
  health_check {
    path                = "/health" # Ensure this path matches your application health endpoint
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}

# Load Balancer Listener
resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-rds-subnet-group"
  subnet_ids = ["subnet-0270f905ad580e53c", "subnet-0b97eefecf821689e", "subnet-0571de9dba3eac6d3"] # Replace with your subnet IDs

  tags = {
    Name = "My DB Subnet Group"
  }
}

# RDS MySQL Instance
resource "aws_db_instance" "my_rds" {
  identifier              = "my-rds"
  engine                  = "mysql"
  engine_version          = "8.0.36" # Use a compatible MySQL engine version
  instance_class          = "db.t3.micro" # Use a compatible instance class
  allocated_storage       = 20
  db_name                 = "mydatabase"
  username                = "admin"
  password                = "password123"
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true
  publicly_accessible     = true
  vpc_security_group_ids  = ["sg-0a4ecf499a9d40c07"]
  db_subnet_group_name    = aws_db_subnet_group.my_db_subnet_group.name
}

# Secrets Manager Secret
resource "aws_secretsmanager_secret" "my_secret" {
  name        = "my_secret_xx"
  description = "This is a dummy secret"
}

resource "aws_secretsmanager_secret_version" "my_secret_version" {
  secret_id     = aws_secretsmanager_secret.my_secret.id
  secret_string = jsonencode({
    username = "admin"
    password = "password123"
  })
}

terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket987"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-terraform-lock-table987"
    encrypt        = true
  }
}

