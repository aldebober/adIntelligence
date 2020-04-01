variable site_certificate {
    default = "cert.pem"
}

variable site_certificate_key {
    default = "cert.key"
}

resource "kubernetes_secret" "tls-secret-demo" {
  type  = "kubernetes.io/tls"

  metadata {
    name      = "cert-test"
    namespace = "monitoring"
  }

  data = {
    "tls.crt" = "${file("${path.module}/certs/${var.site_certificate}")}"
    "tls.key" = "${file("${path.module}/certs/${var.site_certificate_key}")}"
  }
}

output "tls-secret-demo" {
    value = "${kubernetes_secret.tls-secret-demo.metadata.0.name}"
}
