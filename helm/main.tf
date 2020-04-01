variable "do_token" {}

variable "access_key" {}

variable "secret_key" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

variable "cluster-name" {
    default = "mycluster-com"
}

terraform {
    backend "s3" {
        bucket = "adintelligence"
        region = "us-east-1" # required but totally ignored
        endpoint = "https://fra1.digitaloceanspaces.com"
        key = "kube/tf.tfstate"

        # Hey DO Spaces is only S3 compatible not exactly S3
        skip_credentials_validation = true
        skip_metadata_api_check = true
    }
}

data "terraform_remote_state" "cluster" {
  backend = "s3"

  config {
    bucket = "adintelligence"
    endpoint = "https://fra1.digitaloceanspaces.com"
    skip_credentials_validation = true
    skip_metadata_api_check = true
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"

    key     = "tf.tfstate"
    region = "us-east-1" # required but totally ignored
  }
}

provider "kubernetes" {
  host = "${data.terraform_remote_state.cluster.endpoint}"

  token = "${data.terraform_remote_state.cluster.token}"
  client_certificate = "${base64decode(data.terraform_remote_state.cluster.client_certificate)}"
  client_key = "${base64decode(data.terraform_remote_state.cluster.client_key)}"
  cluster_ca_certificate = "${base64decode(data.terraform_remote_state.cluster.cluster_ca_certificate)}"
}

provider "helm" {
  kubernetes {
    host                   = "${data.terraform_remote_state.cluster.endpoint}"
    cluster_ca_certificate = "${base64decode(data.terraform_remote_state.cluster.cluster_ca_certificate)}"
    token                  = "${data.terraform_remote_state.cluster.token}"
    load_config_file       = false
  }
}
