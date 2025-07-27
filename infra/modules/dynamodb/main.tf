resource "aws_dynamodb_table" "vpcs" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "vpc_id"

  attribute {
    name = "vpc_id"
    type = "S"
  }

}
