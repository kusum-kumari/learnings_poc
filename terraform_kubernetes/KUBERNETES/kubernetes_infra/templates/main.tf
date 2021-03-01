provider "kubernetes" {
  config_path    = var.configpath
  config_context = var.configcontext
}

resource "kubernetes_namespace" "test" {
  metadata {
    name = var.ns
  }
}
resource "kubernetes_deployment" "test" {
  metadata {
    name      = var.deployment_metadata_name
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    replicas = var.replica_count
    selector {
      match_labels = {
        app = var.deployment_selector_app_name
      }
    }
    template {
      metadata {
        labels = {
          app = var.deployment_selector_app_name
        }
      }
      spec {
        container {
          image = var.container_image
          name  = var.container_image_name
          port {
            container_port = var.containerport
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "test" {
  metadata {
    name      = var.service_name
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.test.spec.0.template.0.metadata.0.labels.app
    }
    type = var.service_type
    port {
      node_port   = var.service_type_port_node_port
      port        = var.service_type_port_port
      target_port = var.service_type_port_target_port
    }
  }
}

resource "kubernetes_ingress" "test" {
  wait_for_load_balancer = true
  metadata {
    name = "test"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/*"
          backend {
            service_name = kubernetes_service.test.metadata.0.name
            service_port = var.service_type_port_port
          }
        }
      }
    }
  }
}

resource "kubernetes_job" "perl-job" {
  metadata {
    name = var.job_name
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name    = var.job_container_name
          image   = var.job_container_image
          command = var.job_commands
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = var.job_backoff_limit
  }
  wait_for_completion = true
}

resource "kubernetes_cron_job" "cron-job" {
  metadata {
    name = "cron-job"
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    concurrency_policy            = "Replace"
    failed_jobs_history_limit     = 5
    schedule                      = "0 * * * *"
    starting_deadline_seconds     = 10
    successful_jobs_history_limit = 10
    job_template {
      metadata {}
      spec {
        backoff_limit              = 2
        ttl_seconds_after_finished = 10
        template {
          metadata {}
          spec {
            container {
              name    = "hello"
              image   = "busybox"
              command = ["/bin/sh", "-c", "date; echo Hello Kusum Kum"]
            }
          }
        }
      }
    }
  }
}

