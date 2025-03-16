resource "aws_api_gateway_rest_api" "api" {
  name = "${var.project_name}-${var.team_name}-${var.environment}-api"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  tags = {
    Name      = "API Gateway Qa",
    Project   = "Hotel Management System",
    Creator   = "Harsh"
  }
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
  
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "alb" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${var.alb_dns_name}/{proxy}"
  connection_type         = "INTERNET"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "api" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  depends_on  = [aws_api_gateway_integration.alb]
}

resource "aws_api_gateway_stage" "api" {
  deployment_id = aws_api_gateway_deployment.api.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = var.environment

  tags = {
    Name      = "API Gateway Qa",
    Project   = "Hotel Management System",
    Creator   = "Harsh"
  }
}
