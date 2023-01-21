data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda-scripts/lambda.py"
  output_path = "lambda.zip"
}