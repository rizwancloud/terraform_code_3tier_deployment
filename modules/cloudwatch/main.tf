# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/3tawt/app-tier"
  retention_in_days = 7

  tags = {
    Application = "myapp-app-tier"
  }
}


# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "web_logs_access" {
  name              = "/3tawt/web/nginx-access"
  retention_in_days = 7

  tags = {
    Application = "myapp-web-tier-access"
  }
}

resource "aws_cloudwatch_log_group" "web_logs_error" {
  name              = "/3tawt/web/nginx-error"
  retention_in_days = 7

  tags = {
    Application = "myapp-web-tier-error"
  }
}
