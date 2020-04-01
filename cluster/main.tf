variable "do_token" {}
provider "digitalocean" {
  token = "${var.do_token}"
}

# terraform init \
#  -backend-config="access_key=$SPACES_ACCESS_TOKEN" \
#  -backend-config="secret_key=$SPACES_SECRET_KEY" \

terraform {
    required_version = ">= 0.11, < 0.12"
    backend "s3" {
        bucket = "adintelligence"
        region = "us-east-1" # required but totally ignored
        endpoint = "https://fra1.digitaloceanspaces.com"
        key = "tf.tfstate"

        # Hey DO Spaces is only S3 compatible not exactly S3
        skip_credentials_validation = true
        skip_metadata_api_check = true
    }
}

