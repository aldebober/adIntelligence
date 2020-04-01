resource "kubernetes_namespace" "test" {
  metadata {
    name = "test"
    labels {
      env = "test"
    }
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
    labels {
      env = "monitoring"
    }
  }
}

output "monitoring_ns" {
    value = "${kubernetes_namespace.monitoring.metadata.0.name}"
}

output "test_ns" {
    value = "${kubernetes_namespace.test.metadata.0.name}"
}
