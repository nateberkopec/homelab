terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = { 
      source = "hashicorp/helm"
    }
  }
}

variable "host" {
  type = string
}

variable "client_certificate" {
  type = string
}

variable "client_key" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

provider "kubernetes" {
  config_path = "../kubeconfig"
}

provider "helm" {
  kubernetes {
    config_path = "../kubeconfig"
  }
}

resource "kubernetes_service" "pihole_lb" {
  metadata {
    name = "pihole-lb"
  }
  spec {
    selector = {
      app = "pihole"
    }
    port {
      port        = 53
      target_port = 53
    }

    type = "LoadBalancer"
  }
}

resource "helm_release" "pihole" {
  name       = "pihole"
  repository = "https://mojo2600.github.io/pihole-kubernetes/"
  chart      = "pihole"

  values = [
    file("${path.module}/helm/pihole-values.yaml")
  ]
}

/*
resource "helm_release" "home-assistant" {
  name        = "home-assistant"
  repository  = "https://k8s-at-home.com/charts/"
  chart       = "home-assistant"

  values = [
    file("${path.module}/helm/home-assistant-values.yaml")
  ]
}
*/
