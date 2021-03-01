module "kubernetes_infra" {
  source = "../kubernetes_infra/templates"
  configpath = "~/.kube/config"
  configcontext = "minikube"
  ns = "k8s-tf-ns-1"
  deployment_metadata_name = "nginx"
  deployment_selector_app_name = "k8s_tf_frontend_app"
  replica_count = 2
  container_image = "nginx"
  container_image_name = "nginx-controller"
  containerport = 80
  service_type = "NodePort"
  service_name = "ingress-service"
  service_type_port_node_port = 30201
  service_type_port_port = 80
  service_type_port_target_port = 80
  job_name = "perl-job"
  job_container_name = "pi"
  job_container_image = "perl"
  job_commands = ["perl", "-Mbignum=bpi", "-wle", "print bpi(2000)"]
  job_backoff_limit = 4
}

output "kubernetes_infra" {
  value = module.kubernetes_infra
}
