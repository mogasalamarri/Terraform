resource "aws_ecs_cluster" "ecs_cluster" {
  count = length(var.ecsclusters)
  name = lookup(var.ecsclusters[count.index], "ecs_cluster_name")
  tags = {
    Environment = var.environment
    Terraformed = "True"
  }
}



resource "aws_ecs_task_definition" "ecs_task_definition" {
  count                    = length(var.taskdefs)
  family                   = lookup(var.taskdefs[count.index], "tas_family_name")
  task_role_arn             = aws_iam_role.demo_task_execution_role.arn
  execution_role_arn       = aws_iam_role.demo_task_execution_role.arn
  network_mode             = "awsvpc" 
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"  
  memory                   = "512"
  container_definitions    = <<DEFINITION
[
   {
      "name": "demo-container",
      "image": "nginx:latest",
      "cpu": 0,
      "memoryReservation": 128,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80,
          "protocol": "tcp"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "demo-container-logs",
          "awslogs-region": "ap-south-1", 
          "awslogs-stream-prefix": "demo-container"
        }
      }
    }
  ]
  DEFINITION
}


resource "aws_iam_role" "demo_task_execution_role" {
  name = "demo-task-execution-role" 
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "demo_task_execution_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.demo_task_execution_role.name
}



resource "aws_ecs_service" "demo_service" {
  count           = length(var.ecsServices)
  name            = lookup(var.ecsServices[count.index], "ecs_service_name")
  cluster         = aws_ecs_cluster.ecs_cluster[0].id
  task_definition = aws_ecs_task_definition.ecs_task_definition[0].arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets = var.subnetids
    security_groups = var.ecsServicesecurityGroup
    assign_public_ip = true
  }
}