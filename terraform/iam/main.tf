resource "aws_iam_role" "eb_role" {
  name = "my-elasticbeanstalk-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eb_role_policies" {
  count = length([
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
    "arn:aws:iam::aws:policy/AmazonElastiCacheFullAccess"
  ])

  role = aws_iam_role.eb_role.name
  policy_arn = element([
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
    "arn:aws:iam::aws:policy/AmazonElastiCacheFullAccess"
  ], count.index)
}

resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "my-elasticbeanstalk-instance-profile"
  role = aws_iam_role.eb_role.name
}

output "eb_instance_profile" {
  value = aws_iam_instance_profile.eb_instance_profile
}
