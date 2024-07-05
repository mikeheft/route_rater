data "aws_secretsmanager_secret" "creds" {
  arn = "arn:aws:secretsmanager:us-west-2:957986144078:secret:creds-58cfKJ"
}

data "aws_secretsmanager_secret_version" "secret_credentials" {
  secret_id = data.aws_secretsmanager_secret.creds.id
}

output "creds" {
  value = jsondecode(data.aws_secretsmanager_secret_version.secret_credentials.secret_string)
}
