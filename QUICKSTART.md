# Quick Reference Guide

## 🚀 Getting Started (3 Steps)

### 1. Configure Your Credentials

Edit `.env` file and set:

```bash
SUPABASE_PROJECT_REF=your-project-ref
SUPABASE_SERVICE_ROLE_KEY=eyJ...your-key...
GF_SECURITY_ADMIN_PASSWORD=your-secure-password
```

**Where to find these:**

- **Project Ref**: From your Supabase URL: `https://[PROJECT-REF].supabase.co`
- **Service Role Key**: Supabase Dashboard → Settings → API → `service_role` key
  (secret)

### 2. Validate Setup

```bash
validate.bat
```

### 3. Start Monitoring

```bash
start.bat
```

## 📊 Access Points

| Service          | URL                   | Credentials             |
| ---------------- | --------------------- | ----------------------- |
| **Grafana**      | http://localhost:3000 | admin / [your password] |
| **Prometheus**   | http://localhost:9090 | No auth                 |
| **Alertmanager** | http://localhost:9093 | No auth                 |

## 🔧 Common Commands

### Start the stack

```bash
start.bat
```

### Stop the stack

```bash
stop.bat
```

### View logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f prometheus
docker-compose logs -f grafana
docker-compose logs -f alertmanager
```

### Restart a service

```bash
docker-compose restart prometheus
docker-compose restart grafana
```

### Check service status

```bash
docker-compose ps
```

### Remove everything (including data)

```bash
docker-compose down -v
```

## 🔍 Troubleshooting

### Metrics not showing?

1. **Check Prometheus targets:**
   - Go to http://localhost:9090/targets
   - Look for `supabase_metrics` job
   - Should show status "UP"

2. **If status is DOWN:**
   - Verify your service role key in `.env`
   - Check your project ref is correct
   - Ensure you can access `https://[project-ref].supabase.co`

3. **View Prometheus logs:**
   ```bash
   docker-compose logs prometheus
   ```

### Dashboard shows "No Data"?

- Wait 1-2 minutes for initial scrape
- Check time range in Grafana (top right corner)
- Verify Prometheus is collecting data: http://localhost:9090/graph

### Can't login to Grafana?

- Default credentials: `admin` / `admin`
- Or use password from `.env` file
- Reset by stopping containers and removing grafana volume:
  ```bash
  docker-compose down
  docker volume rm fyndr-monitoring_grafana_data
  docker-compose up -d
  ```

### Alerts not firing?

1. Check rules are loaded: http://localhost:9090/rules
2. Check Alertmanager: http://localhost:9093
3. Verify alert thresholds in `docker/prometheus/rules/supabase-alerts.yml`

## 📈 Viewing Metrics

### In Grafana

1. Go to http://localhost:3000
2. Navigate to **Dashboards** → **Supabase** folder
3. Open the Supabase dashboard

### In Prometheus

1. Go to http://localhost:9090
2. Click **Graph**
3. Try these queries:
   ```promql
   # Database size
   pg_database_size_mb

   # Active connections
   pg_stat_database_numbackends

   # Database up/down
   pg_up
   ```

## 🔔 Configuring Alerts

### Slack Notifications

Edit `docker/alertmanager/alertmanager.yml`:

```yaml
receivers:
    - name: "critical-alerts"
      slack_configs:
          - api_url: "https://hooks.slack.com/services/YOUR/WEBHOOK/URL"
            channel: "#alerts"
            title: "{{ .GroupLabels.alertname }}"
            text: "{{ range .Alerts }}{{ .Annotations.description }}{{ end }}"
```

Restart Alertmanager:

```bash
docker-compose restart alertmanager
```

### Email Notifications

```yaml
receivers:
    - name: "critical-alerts"
      email_configs:
          - to: "alerts@yourcompany.com"
            from: "monitoring@yourcompany.com"
            smarthost: "smtp.gmail.com:587"
            auth_username: "your-email@gmail.com"
            auth_password: "your-app-password"
```

## 🎯 Key Metrics to Watch

| Metric                               | What to Watch         | Alert Threshold  |
| ------------------------------------ | --------------------- | ---------------- |
| **pg_up**                            | Database availability | = 0 (down)       |
| **pg_database_size_mb**              | Storage usage         | > 80% of limit   |
| **pg_stat_database_numbackends**     | Connection count      | > 80 connections |
| **physical_replication_lag_seconds** | Replication lag       | > 600 seconds    |
| **pg_stat_activity_max_tx_duration** | Long transactions     | > 3600 seconds   |

## 🔄 Updating

### Update Supabase Dashboard

```bash
cd docker/grafana/dashboards
curl -o supabase-official.json https://raw.githubusercontent.com/supabase/supabase-grafana/refs/heads/main/grafana/dashboard.json
docker-compose restart grafana
```

### Update Docker Images

```bash
docker-compose pull
docker-compose up -d
```

## 🔐 Security Checklist

- [ ] Changed Grafana admin password from default
- [ ] Service role key stored securely in `.env`
- [ ] `.env` file added to `.gitignore`
- [ ] Firewall rules configured (if exposed to internet)
- [ ] SSL/TLS configured (if exposed to internet)
- [ ] Regular key rotation scheduled

## 📚 Useful Links

- [Full README](README.md)
- [Supabase Metrics Docs](https://supabase.com/docs/guides/telemetry/metrics/grafana-self-hosted)
- [Prometheus Query Docs](https://prometheus.io/docs/prometheus/latest/querying/basics/)
- [Grafana Docs](https://grafana.com/docs/)

## 💡 Pro Tips

1. **Bookmark these URLs:**
   - http://localhost:3000 (Grafana)
   - http://localhost:9090/targets (Prometheus targets)
   - http://localhost:9090/alerts (Active alerts)

2. **Set up mobile alerts:**
   - Configure Alertmanager with your preferred notification service
   - Test alerts by temporarily lowering thresholds

3. **Create custom dashboards:**
   - Use the official dashboard as a template
   - Add panels for your specific use cases

4. **Monitor multiple projects:**
   - Add additional scrape jobs in `prometheus.yml`
   - Use labels to distinguish between projects

5. **Regular maintenance:**
   - Check disk usage weekly
   - Review alert thresholds monthly
   - Rotate service role keys quarterly
