resource "aws_s3_bucket" "clicksolution" {
  bucket = local.s3-sufix
}