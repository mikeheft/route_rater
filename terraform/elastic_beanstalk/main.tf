
resource "aws_elastic_beanstalk_application" "hop_skip_drive" {
  name        = "hop-skip-drive-test"
  description = "Simple Beanstalk app for HopSkipDrive"
}

# Define Production Environment
resource "aws_elastic_beanstalk_environment" "production_env" {
  name                = "prod-env"
  application         = aws_elastic_beanstalk_application.hop_skip_drive.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.0.9 running Ruby 3.2"

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DATABASE_URL"
    value     = "postgres://route_rater:${var.db_password}@${var.db_endpoint}:5432/route_rater_production"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "REDIS_URL"
    value     = "redis://${var.redis_host}:${var.redis_port}"
  }
}
