#!/bin/bash

DEST=/home/mdocs.example.org/images
TOKEN=create-a-shared-token-in-grafana
GRAFANA=https://iot.example.com:2130/render/d-solo/wWADWc57k/sdrc-environment

# sample URL
# https://iot.example.com:2130/render/d-solo/wWADWc57k/sdrc-environment?from=now-10m&to=now&orgId=1&theme=light&panelId=6&width=184&height=184&tz=America%2FLos_Angeles

# Outdoor Temp
curl -s -H "Authorization: Bearer $TOKEN" "$GRAFANA?from=now-10m&to=now&orgId=1&theme=light&panelId=6&width=184&height=184&tz=America%2FLos_Angeles"  -o $DEST/outdoortemp.jpg
# Wind Speed
curl -s -H "Authorization: Bearer $TOKEN" "$GRAFANA?from=now-10m&to=now&orgId=1&theme=light&panelId=7&width=184&height=184&tz=America%2FLos_Angeles"  -o $DEST/windspeed.jpg
# Wind Gust
curl -s -H "Authorization: Bearer $TOKEN" "$GRAFANA?from=now-1h&to=now&orgId=1&theme=light&panelId=10&width=184&height=184&tz=America%2FLos_Angeles" -o $DEST/windgust.jpg
# Temp & Wind Speed
curl -s -H "Authorization: Bearer $TOKEN" "$GRAFANA?from=now-3h&to=now&orgId=1&theme=light&panelId=4&width=560&height=250&tz=America%2FLos_Angeles"  -o $DEST/tempwind.jpg

