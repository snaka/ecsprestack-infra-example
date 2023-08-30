resource "aws_iam_role" "ecs_events" {
  name = "${var.conf.prefix}-${var.conf.env}-ecs-event-role"
  assume_role_policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "AllowAssumeRoleForEvents",
          "Effect": "Allow",
          "Principal": {
            "Service": "events.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "ecs_events_managed_policy" {
  role = aws_iam_role.ecs_events.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

resource "aws_iam_role_policy" "ecs_events" {
  name = "ecs-event-policy"
  role = aws_iam_role.ecs_events.id

  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "events:PutTargets",
            "ecs:RunTask",
            "events:PutRule",
            "events:ListTargetsByRule",
          ],
          "Resource": [
            "arn:aws:ecs:ap-northeast-1:${var.conf.account_id}:task-definition/*:*",
            "arn:aws:events:*:${var.conf.account_id}:rule/*",
          ]
        },
        {
          "Effect": "Allow",
          "Action": [
            "events:ListRules",
            "ecs:DescribeTaskDefinition",
          ]
          "Resource": "*"
        },
        {
          "Effect": "Allow",
          "Action": "iam:PassRole",
          "Resource": aws_iam_role.task_execution.arn
        }
      ]
    }
  )
}

resource "aws_iam_role" "task_execution" {
  name = "${var.conf.prefix}-${var.conf.env}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement": [
      {
        "Sid": "AllowAssumeRoleForTaskExecution",
        "Effect": "Allow",
        "Principal": {
          "Service": "ecs-tasks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "task_execution_role_policy" {
  role = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "task_execution" {
  name = "ecs-task-execution-policy"
  role = aws_iam_role.task_execution.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement": [
      {
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "ssm:GetParameters",
          "secretsmanager:GetSecretValue",
          "kms:Decrypt",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecs:DescribeClusters",
          "ecs:DescribeTaskDefinition",
          "ecs:RunTask",
          "events:DeleteRule",
          "events:ListRules",
          "events:ListTargetsByRule",
          "events:PutRule",
          "events:PutTargets",
          "events:RemoveTargets",
          "iam:GetRole",
          "iam:PassRole"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_exec" {
  name = "ecs-exec-policy"
  role = aws_iam_role.task_execution.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ],
        "Resource": "*"
      }
    ]
  })
}
