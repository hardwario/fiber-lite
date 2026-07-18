#!/usr/bin/env bash
set -euo pipefail

sudo apt-get install -y apt-transport-https wget gnupg
sudo mkdir -p /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/grafana.asc https://apt.grafana.com/gpg-full.key
sudo chmod 644 /etc/apt/keyrings/grafana.asc
echo "deb [signed-by=/etc/apt/keyrings/grafana.asc] https://apt.grafana.com stable main" \
  | sudo tee /etc/apt/sources.list.d/grafana.list

sudo apt-get update
sudo apt-get install -y grafana
sudo systemctl enable --now grafana-server

read -rsp "Choose a new Grafana admin password: " GRAFANA_PASSWORD; echo
curl -sf -X PUT http://localhost:3000/api/admin/users/1/password \
  -u admin:admin -H "Content-Type: application/json" \
  -d "{\"password\":\"$GRAFANA_PASSWORD\"}" > /dev/null

read -rp "InfluxDB API token (from 070-install-influxdb.sh output): " INFLUX_TOKEN
curl -sf -X POST http://localhost:3000/api/datasources \
  -u "admin:$GRAFANA_PASSWORD" -H "Content-Type: application/json" \
  -d "{
    \"name\": \"InfluxDB fiber-lite\", \"type\": \"influxdb\", \"access\": \"proxy\",
    \"url\": \"http://localhost:8086\",
    \"jsonData\": {\"version\": \"Flux\", \"organization\": \"fiber-lite\", \"defaultBucket\": \"fiber-lite\", \"tlsSkipVerify\": true},
    \"secureJsonData\": {\"token\": \"$INFLUX_TOKEN\"}
  }" > /dev/null

echo
echo "Grafana running on :3000, InfluxDB datasource added."
echo "Dashboard panels are best built once real device/gateway data exists to visualize."
