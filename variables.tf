variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "team_name" {
  description = "Name of the team"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., Qa, prod)"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the ALB"
  type        = string
}
