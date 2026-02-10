# Supabase Monitoring with Prometheus & Grafana

This setup monitors your Supabase database using Prometheus for metrics
collection and Grafana for visualization.

## Architecture

1. **Prometheus** scrapes metrics from your Supabase project every 60 seconds
2. **Grafana** visualizes the metrics with pre-built dashboards
3. **Alertmanager** sends notifications when alerts are triggered

## Prerequisites

- Docker and Docker Compose installed
- Supabase project with access to the service role key
- Network access to `*.supabase.co`

## Setup Instructions

### 1. Configure Environment Variables

Copy the example environment file and update it with your credentials:

```bash
cp .env.example .env
```

Edit `.env` and set:

- `SUPABASE_PROJECT_REF`: Your Supabase project reference (from your project
  URL)
- `SUPABASE_SERVICE_ROLE_KEY`: Your service role key (get from Supabase
  Dashboard → Settings → API)
- `GF_SECURITY_ADMIN_PASSWORD`: Password for Grafana admin user

### 2. Start the Monitoring Stack

```bash
docker-compose up -d
```

This will start:

- **Prometheus** on http://localhost:9090
- **Grafana** on http://localhost:3000
- **Alertmanager** on http://localhost:9093

### 3. Access Grafana

1. Open http://localhost:3000 in your browser
2. Login with:
   - Username: `admin`
   - Password: (the value you set in `.env`)

3. The Supabase dashboard should be automatically loaded from
   `docker/grafana/dashboards/supabase-official.json`

### 4. Verify Metrics Collection

1. Go to Prometheus at http://localhost:9090
2. Navigate to **Status → Targets**
3. Verify that the `supabase_metrics` job shows as "UP"
4. If it's down, check:
   - Your service role key is correct
   - Your project reference is correct
   - You have network access to `*.supabase.co`

### 5. Configure Alerting (Optional)

Edit `docker/alertmanager/alertmanager.yml` to configure notification channels:

**Example: Slack Notifications**

```yaml
receivers:
    - name: "critical-alerts"
      slack_configs:
          - api_url: "YOUR_SLACK_WEBHOOK_URL"
            channel: "#alerts"
            title: "Critical Alert: {{ .GroupLabels.alertname }}"
            text: "{{ range .Alerts }}{{ .Annotations.description }}{{ end }}"
```

**Example: Email Notifications**

```yaml
receivers:
    - name: "critical-alerts"
      email_configs:
          - to: "your-email@example.com"
            from: "alertmanager@example.com"
            smarthost: "smtp.gmail.com:587"
            auth_username: "your-email@gmail.com"
            auth_password: "your-app-password"
```

After updating, restart Alertmanager:

```bash
docker-compose restart alertmanager
```

## Available Dashboards

The official Supabase dashboard (`supabase-official.json`) includes 200+ panels
covering:

- **Database Health**: CPU, memory, disk usage
- **Query Performance**: Query throughput, latency, slow queries
- **Connections**: Active connections, connection pool status
- **Replication**: Replication lag, WAL status
- **Storage**: Database size, table sizes, index bloat
- **Locks**: Lock contention, deadlocks

## Alert Rules

The following alerts are configured in
`docker/prometheus/rules/supabase-alerts.yml`:

| Alert                      | Severity | Condition                    | Description                       |
| -------------------------- | -------- | ---------------------------- | --------------------------------- |
| PostgresDatabaseDown       | Critical | Database down for 5+ minutes | Database is unreachable           |
| PostgresReplicationLagHigh | Warning  | Replication lag > 10 minutes | Replication is falling behind     |
| PostgresDatabaseSizeGrowth | Warning  | 20%+ growth in 12 hours      | Rapid database growth             |
| HighDiskUsage              | Critical | Disk usage > 80%             | Running out of disk space         |
| HighConnectionCount        | Warning  | Connections > 80             | High connection count             |
| LongRunningTransactions    | Warning  | Transaction > 1 hour         | Long-running transaction detected |
| TooManyIdleConnections     | Warning  | Idle connections > 50        | Too many idle connections         |

## Customizing Alert Thresholds

Edit `docker/prometheus/rules/supabase-alerts.yml` to adjust thresholds based on
your project size:

```yaml
# Example: Change disk usage threshold from 80% to 90%
- alert: HighDiskUsage
  expr: (pg_database_size_mb / 8192) * 100 > 90 # Changed from 80 to 90
```

After updating, reload Prometheus:

```bash
docker-compose exec prometheus kill -HUP 1
```

## Troubleshooting

### Metrics not showing in Grafana

1. Check Prometheus targets: http://localhost:9090/targets
2. Verify the `supabase_metrics` job is "UP"
3. Check Prometheus logs: `docker-compose logs prometheus`

### Authentication errors

- Verify your service role key is correct (should start with `eyJ...`)
- Ensure you're using the `service_role` key, not the `anon` key
- Check that the key hasn't been rotated in Supabase Dashboard

### Dashboard shows "No Data"

- Wait 1-2 minutes for initial metrics to be scraped
- Check the time range in Grafana (top right)
- Verify Prometheus is scraping successfully

### Alerts not firing

1. Check Prometheus rules are loaded: http://localhost:9090/rules
2. Verify Alertmanager is running: http://localhost:9093
3. Check Alertmanager logs: `docker-compose logs alertmanager`

## Maintenance

### Updating Dashboards

To update to the latest Supabase dashboard:

```bash
cd docker/grafana/dashboards
curl -o supabase-official.json https://raw.githubusercontent.com/supabase/supabase-grafana/refs/heads/main/grafana/dashboard.json
docker-compose restart grafana
```

### Backup Configuration

Important files to backup:

- `.env` (contains credentials)
- `docker/prometheus/prometheus.yml`
- `docker/prometheus/rules/supabase-alerts.yml`
- `docker/alertmanager/alertmanager.yml`

### Data Retention

By default, Prometheus retains metrics for 15 days. To change this, update
`docker-compose.yml`:

```yaml
prometheus:
    command:
        - "--storage.tsdb.retention.time=30d" # Keep for 30 days
```

## Security Best Practices

1. **Rotate Keys Regularly**: Update your service role key periodically
2. **Use Secrets Manager**: In production, use Docker secrets or a secrets
   manager
3. **Restrict Access**: Use firewall rules to limit access to Grafana/Prometheus
4. **Enable HTTPS**: Put Grafana behind a reverse proxy with SSL
5. **Strong Passwords**: Use a strong password for Grafana admin

## Resources

- [Supabase Metrics Documentation](https://supabase.com/docs/guides/telemetry/metrics/grafana-self-hosted)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Supabase Grafana Repository](https://github.com/supabase/supabase-grafana)

## Support

For issues specific to:

- **Supabase metrics**: Check [Supabase Support](https://supabase.com/support)
- **Prometheus/Grafana**: Check their respective documentation
- **This setup**: Review the troubleshooting section above
