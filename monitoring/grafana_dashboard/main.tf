terraform {
    required_providers {
        grafana = {
        source  = "grafana/grafana"
        version = "3.15.3"
        }
    }
}

provider "grafana" {
    url = var.grafana_url
    auth = var.grafana_auth
    insecure_skip_verify = true
}

resource "grafana_data_source" "prometheus-ds" {
    name = "Prometheus"
    type = "prometheus"
    url = var.data_source_url
}

resource "grafana_folder" "java_folder" {
  title = "JVM Folder"
}

resource "grafana_dashboard" "test" {
  folder = grafana_folder.java_folder.uid
  config_json = file(var.dashboard_json)
}