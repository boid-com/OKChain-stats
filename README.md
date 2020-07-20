## OKChain-stats

This repo was created for the OKchain Hackathon 2020 (https://www.okex.com/academy/en/the-first-okchain-hackathon-campaign-announcement)
This project is a proof of concept to show how okchain specific information can be injected into a prometheus timeseries db and
visualized via Grafana for analysis.

The following steps are need to install the full setup:

## Pre-requirements
```
apt install jq haproxy certbot
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EA312927
apt install libfontconfig1
curl -LO https://dl.grafana.com/oss/release/grafana_6.4.3_amd64.deb
dpkg -i grafana_6.4.3_amd64.deb
curl -LO https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
curl -LO https://github.com/prometheus/prometheus/releases/download/v2.19.2/prometheus-2.19.2.linux-amd64.tar.gz
```

grab the binaries (prometheus and node_exporter)  and put them in /usr/local/bin
copy the systemd service files 
```
cp systemd-configs/*.service /usr/lib/systemd/system
```
Setup prometheus and start services
```
useradd prometheus
mkdir /etc/prometheus
mkdir /var/spool/prometheus
chown -R prometheus.prometheus /etc/prometheus /var/spool/prometheus
cp prometheus.yml to /etc/prometheus folder
systemctl daemon-reload
systemctl enable prometheus
systemctl enable node_exporter
systemctl start prometheus
systemctl start node_exporter
```

node_exporter is configured with the textfile collector, we will be used this to inject okchain metrics
extracted from okchaincli
Setup a cronjob for grabOKchain.sh
```
cp grabOKchain.sh /usr/local/bin
mkdir /var/spool/okchain
crontab -e

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/2 * * * * /usr/local/bin/grabOKchain.sh  >> /var/log/okchain.log 2>&1
```
You should now see /var/spool/okchain/okchain.prom file
prometheus will pick this up automatically.

Now you can load the okchain-validator-dashboard.json via grafana




