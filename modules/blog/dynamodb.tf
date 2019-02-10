resource "aws_dynamodb_table" "secretsandlies" {
  name           = "secretsandlies"
  hash_key       = "key"
  read_capacity  = "5"
  write_capacity = "5"
  stream_enabled = false

  server_side_encryption = {
    enabled = true
  }

  point_in_time_recovery {
    enabled = false
  }

  attribute {
    name = "key"
    type = "S"
  }
}
