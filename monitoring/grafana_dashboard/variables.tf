variable "grafana_url" {
    description = "The URL of the Grafana instance"
    type        = string
    default = "http://localhost:3000"
}

variable "grafana_auth" {
    description = "The API key for Grafana"
    type        = string
    default = "admin:testgrafana2!2@"
}

# data source
variable "data_source_url" {
    description = "The URL of the data source"
    type        = string
    default     = "http://prometheus:9090"
}

# dashboard
variable "dashboard_json" {
    description = "The JSON content of the dashboard"
    type        = string
    default     = "10519_jvm_dashboard.json"
  
}