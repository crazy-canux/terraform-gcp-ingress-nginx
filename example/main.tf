locals {
  project         = data.terraform_remote_state.vpc.outputs.project
  region          = data.terraform_remote_state.vpc.outputs.region
  labels          = data.terraform_remote_state.vpc.outputs.labels
  cluster_name    = data.terraform_remote_state.gke.outputs.name
  namespace       = "ingress-nginx"
}

###############################
# Data
###############################
data "google_client_config" "this" {}

data "google_container_cluster" "this" {
  name     = local.cluster_name
  location = local.region
}

data "terraform_remote_state" "gke" {
  backend = "gcs"
  config = {
    bucket = "myproject-tst-iac"
    prefix = "terraform/eu-west-4/gke.tfstate"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "gcs"
  config = {
    bucket = "myproject-tst-iac"
    prefix = "terraform/eu-west-4/vpc.tfstate"
  }
}

##############################
# Provider
##############################
provider "google" {
  project = local.project
  region  = local.region
}

provider "helm" {
  kubernetes {
    token                  = data.google_client_config.this.access_token
    host                   = "https://${data.google_container_cluster.this.endpoint}"
    cluster_ca_certificate = base64decode(data.google_container_cluster.this.master_auth[0].cluster_ca_certificate)
  }
}

provider "kubernetes" {
  token                  = data.google_client_config.this.access_token
  host                   = "https://${data.google_container_cluster.this.endpoint}"
  cluster_ca_certificate = base64decode(data.google_container_cluster.this.master_auth[0].cluster_ca_certificate)
}

##############################
# Module/Resources
##############################
module "ingress_nginx" {
  source                 = "../../terraform-ingress-nginx"
  namespace = local.namespace
  extra_set_values = [{
    name  = "nodeSelector.kubernetes\\.io/arch"
    value = "arm64"
    type  = "string"
  }]
}
