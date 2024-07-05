variable "db_password" {
  type = string
}

variable "db_endpoint" {
  description = "DB Endpoint"
  type        = string
}
variable "redis_host" {
  description = "Redis host"
  type        = string
}

variable "redis_port" {
  description = "Redis port"
  type        = number
}
