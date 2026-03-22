#!/bin/bash

[[ $(uname -m) == "aarch64" ]] && arch="arm64" || arch="amd64"

echo "Installing grafana"
echo "See https://grafana.com/grafana/download?edition=oss&platform=arm for more info"
sudo apt-get install -y adduser libfontconfig1 musl
wget -O /tmp/grafana.deb "https://dl.grafana.com/grafana/release/12.4.1/grafana_12.4.1_22846628243_linux_$arch.deb"
sudo dpkg -i /tmp/grafana.deb 

echo "Installing node exporter"
echo "See https://prometheus.io/docs/guides/node-exporter/ for more info"
mkdir /tmp/node_exporter/
wget -O /tmp/node_exporter/node_exporter.tar.gz "https://github.com/prometheus/node_exporter/releases/download/v1.10.2/node_exporter-1.10.2.linux-$arch.tar.gz"

echo "Installing prometheus"
mkdir /tmp/prometheus/
wget -O /tmp/prometheus/prometheus.tar.gz "https://github.com/prometheus/prometheus/releases/download/v3.10.0/prometheus-3.10.0.linux-$arch.tar.gz"
cp "$PWD/prometheus.yml" /tmp/prometheus/
cp -r "$PWD/rules/" /tmp/prometheus/

echo "Installing alertmanager"
echo "See https://prometheus.io/docs/alerting/latest/configuration/"
mkdir /tmp/alertmanager/
wget -O /tmp/alertmanager/alertmanager.tar.gz "https://github.com/prometheus/alertmanager/releases/download/v0.31.1/alertmanager-0.31.1.linux-$arch.tar.gz"
cp "$PWD/alertmanager.yml" /tmp/alertmanager/

sudo cp grafana.ini /etc/grafana/grafana.ini
sudo systemctl restart grafana-server

cd /tmp/prometheus/ && tar xzvf prometheus.tar.gz
cd /tmp/alertmanager/ && tar xzvf alertmanager.tar.gz
cd /tmp/node_exporter/ && tar xzvf node_exporter.tar.gz