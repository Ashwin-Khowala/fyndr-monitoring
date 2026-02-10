#!/bin/sh
# Substitute environment variables in prometheus.yml using sed
sed "s|\${SUPABASE_SERVICE_ROLE_KEY}|${SUPABASE_SERVICE_ROLE_KEY}|g" /etc/prometheus/prometheus.yml.template > /etc/prometheus/prometheus.yml

# Start Prometheus with the provided arguments
exec /bin/prometheus "$@"
