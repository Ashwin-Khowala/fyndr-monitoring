#!/bin/sh
# Substitute environment variables in alertmanager.yml using sed
sed -e "s|\${SMTP_SMARTHOST}|${SMTP_SMARTHOST}|g" \
    -e "s|\${SMTP_FROM}|${SMTP_FROM}|g" \
    -e "s|\${SMTP_AUTH_USERNAME}|${SMTP_AUTH_USERNAME}|g" \
    -e "s|\${SMTP_AUTH_PASSWORD}|${SMTP_AUTH_PASSWORD}|g" \
    -e "s|\${ALERT_EMAIL_DESTINATION}|${ALERT_EMAIL_DESTINATION}|g" \
    /etc/alertmanager/alertmanager.yml.template > /etc/alertmanager/alertmanager.yml

# Start Alertmanager with the provided arguments
exec /bin/alertmanager "$@"
