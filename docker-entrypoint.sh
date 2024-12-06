#!/bin/sh
set -e

if [ ! -z "$ZIGBEE2MQTT_DATA" ]; then
    DATA="$ZIGBEE2MQTT_DATA"
else
    DATA="/app/zigbee2mqtt/data"
fi

echo "Using '$DATA' as data directory"

if [ ! -f "$DATA/configuration.yaml" ]; then
    echo "Creating configuration file..."
    cp /app/zigbee2mqtt/data/configuration.example.yaml "$DATA/configuration.yaml"
fi

exec "$@"
