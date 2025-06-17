resource "aws_dynamodb_table" "scheduling_table" {
  name           = "soso-scheduling-metadata"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "job_id"

  attribute {
    name = "job_id"
    type = "S"
  }

  tags = {
    Name = "soso-dynamodb"
  }
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.scheduling_table.name
}
