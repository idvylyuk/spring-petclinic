#!/usr/bin/bash

docker run --name loki -d \
-v "$(pwd)/monitoring/logs/loki-config.yaml:/etc/loki/loki-config.yml" \
 --network prometheus-monitoring \
 -p 3100:3100 grafana/loki:3.2.1 -config.file=/etc/loki/loki-config.yml 


docker run -d --name promtail \
-v "$(pwd)/monitoring/logs:/var/log" \
-v "$(pwd)/monitoring/logs/promtail-config.yml:/etc/promtail/config.yml" \
--network prometheus-monitoring \
grafana/promtail:3.2.1 \
-config.file=/etc/promtail/config.yml 
