resource "aws_s3_bucket" "my_bucket" {
  bucket = "ganesh-terraform-local-stuff-bucket"

}

resource "aws_dynamodb_table" "my_dynamo_table" {
  name         = "ganesh-terraform-local-stuff-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
