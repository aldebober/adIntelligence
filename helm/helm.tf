
data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com/"
}

data "helm_repository" "nginx-stable" {
  name = "nginx-stable"
  url  = "https://helm.nginx.com/stable"

}

resource "helm_release" "default" {
  repository = "${data.helm_repository.stable.metadata.0.name}"
  name  = "my-prometheus-operator"
  chart = "stable/prometheus-operator"
  namespace = "${kubernetes_namespace.monitoring.metadata.0.name}"

  timeout = 1200
#  force_update = true

  values = [<<EOF
prometheus:
  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: nginx
      nginx.ingress.kubernetes.io/ssl-passthrough: "true"
      nginx.ingress.kubernetes.io/secure-backends: "true"
    hosts:
      - "prometheus.test.local"
    paths:
      - "/"
    tls:
      - secretName: "cert-test"
        hosts:
          - "prometheus.test.local"
grafana:
  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: nginx
      nginx.ingress.kubernetes.io/ssl-passthrough: "true"
      nginx.ingress.kubernetes.io/secure-backends: "true"
    hosts:
      - "grafana.test.local"
    paths:
      - "/"
    tls:
      - secretName: "cert-test"
        hosts:
          - "grafana.test.local"
alertmanager:
  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: nginx
      nginx.ingress.kubernetes.io/ssl-passthrough: "true"
      nginx.ingress.kubernetes.io/secure-backends: "true"
    hosts:
      - "alert.test.local"
    paths:
      - "/"
    tls:
      - secretName: "cert-test"
        hosts:
          - "alert.test.local"

EOF
  ]
}

## Access to Grafana
# kubectl port-forward $(kubectl get pods --selector=app.kubernetes.io/name=grafana -n monitoring --output=jsonpath="{.items..metadata.name}" ) 3000 -n monitoring
# login/pass: admin/prom-operator


resource "helm_release" "ingress" {
  repository = "${data.helm_repository.nginx-stable.metadata.0.name}"
  name  = "nginx-ingress"
  chart = "nginx-stable/nginx-ingress"

  values = [<<EOF
controller:
  metrics:
    port: 9113
    # if this port is changed, change healthz-port: in extraArgs: accordingly
    enabled: true

    service:
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "9090"

    serviceMonitor:
      enabled: true
      additionalLabels: {}
      namespace: ""
      namespaceSelector:
        any: true
      scrapeInterval: 30s
      # honorLabels: true

    prometheusRule:
      enabled: true
      additionalLabels: {}
      namespace: ""
      rules: []

EOF
]

  set {
    name = "controller.metrics.enabled"
    value = "true"
  }

  set {
    name  = "controller.publishService.enabled"
    value = "true"
  }

  force_update = true
  timeout = 1200
}
