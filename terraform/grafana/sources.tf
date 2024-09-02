resource "grafana_data_source" "influxdb_telegraf" {
  name          = "InfluxDB (Telegraf)"
  type          = "influxdb"
  url           = "http://influxdb.monitoring.svc.cluster.local:8086/"
  database_name = "telegraf"
  uid           = "influxdb-telegraf"
}