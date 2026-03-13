resource "null_resource" "example" {}

resource "aws_s3_bucket" "tag_test" {
  bucket = "atlantis-example-tag-test-1234567890"

  tags = {
    Environment = "dev"
    # Intentionally missing Project, DeployedBy, GitPath
  }
}
