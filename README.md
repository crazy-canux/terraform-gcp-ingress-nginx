# terraform ingress nginx controller

deploy ingress-nginx controller.

## Synopsis

provider

    provider "google" {
      project = local.project
      region  = local.region
    }

    provider "helm" {
      kubernetes {
        host                   = "https://${data.google_container_cluster.this.endpoint}"
        cluster_ca_certificate = base64decode(data.google_container_cluster.this.master_auth[0].cluster_ca_certificate)
        token                  = data.google_client_config.this.access_token
      }
    }

    provider "kubernetes" {
      host                   = "https://${data.google_container_cluster.this.endpoint}"
      cluster_ca_certificate = base64decode(data.google_container_cluster.this.master_auth[0].cluster_ca_certificate)
      token                  = data.google_client_config.this.access_token
    }

module

    module "ingress_nginx" {
      source                 = "../../terraform-ingress-nginx"
      namespace = local.namespace
    }
