# IAM Role and Policy for Lambda Function to Access S3 Buckets
resource "aws_iam_role" "lambda_role" {
  name = "s3-backup-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Policy Attachment to Allow Lambda Function to Access S3 Buckets
resource "aws_iam_role_policy" "lambda_policy" {
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::qamar-s3-backup-source"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = "arn:aws:s3:::qamar-s3-backup-source/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::qamar-s3-backup-destination/*"
      },
# CloudWatch Logs permissions for Lambda
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# Lambda Function to Backup S3 Bucket
resource "aws_lambda_function" "s3_backup" {
  function_name = "s3-backup-lambda"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"

  role          = aws_iam_role.lambda_role.arn

  filename      = "lambda_function.zip"

  source_code_hash = filebase64sha256("lambda_function.zip")
}
# EventBridge Rule to Trigger Lambda Daily
resource "aws_cloudwatch_event_rule" "daily_backup" {
    name                = "s3-backup-daily"
    description         = "Trigger S3 backup Lambda function daily"
    schedule_expression = "cron(0 2 * * ? *)"  # Daily at 2 AM UTC
}

# EventBridge Target
resource "aws_cloudwatch_event_target" "lambda_target" {
    rule      = aws_cloudwatch_event_rule.daily_backup.name
    target_id = "S3BackupLambda"
    arn       = aws_lambda_function.s3_backup.arn
}

# Lambda Permission for EventBridge
resource "aws_lambda_permission" "allow_eventbridge" {
    statement_id  = "AllowExecutionFromEventBridge"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.s3_backup.function_name
    principal     = "events.amazonaws.com"
    source_arn    = aws_cloudwatch_event_rule.daily_backup.arn
}
