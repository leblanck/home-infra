#!/bin/bash

#######
#   This was built to be run on Raspberry Pi 3 running raspbianOS 11
#       - Will likely need to be run with sudo
#   KL - 1/11/23


# Download Installer
mkdir -p ~/node_exporter && cd ~/node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-armv6.tar.gz

# unzip
tar -xvzf node_exporter-1.5.0.linux-armv6.tar.gz

# Config node_exporter
cp node_exporter-1.5.0.linux-armv6/node_exporter /usr/local/bin
chmod +x /usr/local/bin/node_exporter
useradd -m -s /bin/bash node_exporter
mkdir -p /var/lib/node_exporter
chown -R node_exporter:node_exporter /var/lib/node_exporter
touch /etc/systemd/system/node_exporter.service

cat <<EOT >> /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter

[Service]
# Provide a text file location for https://github.com/fahlke/raspberrypi_exporter data with the
# --collector.textfile.directory parameter.
ExecStart=/usr/local/bin/node_exporter --collector.textfile.directory /var/lib/node_exporter/textfile_collector

[Install]
WantedBy=multi-user.target
EOT

# enable node_exporter service
systemctl daemon-reload
systemctl enable node_exporter.service
systemctl start node_exporter.service