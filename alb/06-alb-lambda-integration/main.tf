resource "aws_lambda_function" "lambda" {
  function_name    = "my-lambda-backend"
  runtime          = "python3.9"
  timeout          = 30
  role             = aws_iam_role.lambda.arn
  filename         = data.archive__file.lambda.output_path
  handler          = "lambda.handler"
  source_code_hash = data.archive__file.lambda.output_base64sha256
}

resource "aws_iam_role" "lambda" {
  name        = "my-lambda-role"
  description = "Role for lambda function called by load balancer"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_lb" "lb" {
  name = "my-loadbalancer"
  load_balancer_type = "application"
  internal = false 
  subnets = "???"
  security_groups = ["???"]
}

resource "aws_lb_target_group" "lambda" {
  name        = "lambda-tg"
  target_type = "lambda"
}

resource "aws_lb_target_group_attachment" "lambda" {
  target_group_arn = aws_lb_target_group.lambda.arn
  target_id        = aws_lambda_function.lambda.arn

  depends_on = [
    aws_lambda_permission.permission
  ]
}

resource "aws_lambda_permission" "permission" {
  statement_id  = "AllowExecutionFromALB"
  principal     = "elasticloadbalancer.amazonaws.com"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  source_arn    = aws_lb_target_group.lambda.arn
}

resource "aws_lb_listener_rule" "lambda" {
  listener_arn = aws_lb.lb.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lambda.arn
  }

  condition {
    path_pattern {
      values = ["/lambda"]
    }
  }
}