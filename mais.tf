provider "aws" {
  region = "us-east-1"
}

resource "aws_dynamodb_table" "ddbtable" {
  name         = "db_table"
  hash_key     = "id"
  billing_mode = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_iam_role_policy" "write_policy" {
  name   = "lambda_write_policy"
  role   = aws_iam_role.registerRole.id
  policy = file("./registerRole/write_policy.json")
}

resource "aws_iam_role_policy" "read_policy" {
  name   = "lambda_read_policy"
  role   = aws_iam_role.getRole.id
  policy = file("./getRole/read_policy.json")
}

resource "aws_iam_role" "registerRole" {
  name   = "register_person_role"
  assume_role_policy = file("./registerRole/assume_write_policy_teste.json") # Removido _teste
}

resource "aws_iam_role" "getRole" {
  name   = "get_person_role"
  assume_role_policy = file("./getRole/assume_read_policy.json")
}

resource "aws_lambda_function" "registerLambda" {
  function_name = "registerLambda"
  s3_bucket     = "terraform-serverless-dio-romario"
  s3_key        = "registerPerson.zip"
  role          = aws_iam_role.registerRole.arn
  handler       = "registerPerson.handler"
  runtime       = "nodejs18.x" # Atualizado para Node.js 18.x
}

resource "aws_lambda_function" "getLambda" {
  function_name = "getLambda"
  s3_bucket     = "terraform-serverless-dio-romario"
  s3_key        = "getPerson.zip"
  role          = aws_iam_role.getRole.arn
  handler       = "getPerson.handler"
  runtime       = "nodejs18.x" # Atualizado para Node.js 18.x
}

resource "aws_api_gateway_rest_api" "apiLambda" {
  name = "terraApi-dio"
}

resource "aws_api_gateway_resource" "writeResource" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  parent_id   = aws_api_gateway_rest_api.apiLambda.root_resource_id
  path_part   = "insert"
}

resource "aws_api_gateway_method" "writeMethod" {
  rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
  resource_id   = aws_api_gateway_resource.writeResource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_resource" "readResource" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  parent_id   = aws_api_gateway_rest_api.apiLambda.root_resource_id
  path_part   = "get"
}

resource "aws_api_gateway_method" "readMethod" {
  rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
  resource_id   = aws_api_gateway_resource.readResource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "writeInt" {
  rest_api_id             = aws_api_gateway_rest_api.apiLambda.id
  resource_id             = aws_api_gateway_resource.writeResource.id
  http_method             = aws_api_gateway_method.writeMethod.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.registerLambda.invoke_arn
}

resource "aws_api_gateway_integration" "readInt" {
  rest_api_id             = aws_api_gateway_rest_api.apiLambda.id
  resource_id             = aws_api_gateway_resource.readResource.id
  http_method             = aws_api_gateway_method.readMethod.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.getLambda.invoke_arn
}

resource "aws_api_gateway_deployment" "apideploy" {
  depends_on = [
    aws_api_gateway_integration.writeInt,
    aws_api_gateway_integration.readInt
  ]
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  stage_name  = "dev"
}

output "base_url" {
  value = aws_api_gateway_deployment.apideploy.invoke_url
}