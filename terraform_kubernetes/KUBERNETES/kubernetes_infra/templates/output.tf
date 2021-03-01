# Display load balancer IP (typically present in GCP, or using Nginx ingress controller)
output "load_balancer_ip" {
  value = kubernetes_ingress.test.status.0.load_balancer.0.ingress.0.ip
}