# Project Structure

```
fyndr-monitoring/
├── .env                          # Environment variables (DO NOT COMMIT)
├── .env.example                  # Environment template
├── .gitignore                    # Git ignore rules
├── docker-compose.yml            # Docker orchestration
├── README.md                     # Full documentation
├── QUICKSTART.md                 # Quick reference guide
├── start.bat                     # Windows start script
├── start.sh                      # Linux/Mac start script
├── stop.bat                      # Windows stop script
├── validate.bat                  # Setup validation script
│
└── docker/
    ├── prometheus/
    │   ├── prometheus.yml        # Prometheus configuration
    │   └── rules/
    │       └── supabase-alerts.yml  # Alert rules
    │
    ├── grafana/
    │   ├── dashboards/
    │   │   └── supabase-official.json  # Official Supabase dashboard
    │   └── provisioning/
    │       ├── datasources/
    │       │   └── prometheus.yml      # Prometheus datasource config
    │       └── dashboards/
    │           └── dashboards.yaml     # Dashboard provisioning config
    │
    └── alertmanager/
        └── alertmanager.yml      # Alertmanager configuration
```

## File Descriptions

### Root Level

- **`.env`** - Contains sensitive configuration (service role key, passwords)
- **`.env.example`** - Template for environment variables
- **`.gitignore`** - Prevents committing sensitive files
- **`docker-compose.yml`** - Defines all services and their configuration
- **`README.md`** - Comprehensive documentation
- **`QUICKSTART.md`** - Quick reference for common tasks
- **`start.bat`** - Windows script to start the stack
- **`start.sh`** - Linux/Mac script to start the stack
- **`stop.bat`** - Windows script to stop the stack
- **`validate.bat`** - Validates setup before starting

### Prometheus Configuration

- **`docker/prometheus/prometheus.yml`**
  - Global scrape settings
  - Supabase metrics scrape job
  - Alertmanager integration
  - Rule file loading

- **`docker/prometheus/rules/supabase-alerts.yml`**
  - Database health alerts
  - Performance alerts
  - Resource usage alerts
  - Replication alerts

### Grafana Configuration

- **`docker/grafana/dashboards/supabase-official.json`**
  - Official Supabase dashboard with 200+ panels
  - Covers all key metrics

- **`docker/grafana/provisioning/datasources/prometheus.yml`**
  - Configures Prometheus as data source
  - Auto-provisioned on startup

- **`docker/grafana/provisioning/dashboards/dashboards.yaml`**
  - Configures dashboard auto-loading
  - Points to dashboards directory

### Alertmanager Configuration

- **`docker/alertmanager/alertmanager.yml`**
  - Alert routing rules
  - Notification channels
  - Inhibition rules

## Configuration Flow

1. **Environment Variables** (`.env`)
   - Loaded by Docker Compose
   - Injected into containers

2. **Prometheus**
   - Reads `prometheus.yml` for scrape config
   - Uses service role key from environment
   - Loads alert rules from `rules/` directory
   - Sends alerts to Alertmanager

3. **Grafana**
   - Auto-provisions Prometheus datasource
   - Auto-loads dashboards from `dashboards/` directory
   - Connects to Prometheus for data

4. **Alertmanager**
   - Receives alerts from Prometheus
   - Routes to configured receivers
   - Manages alert lifecycle

## Data Persistence

Docker volumes are used for data persistence:

- **`prometheus_data`** - Stores metrics data (15 days by default)
- **`grafana_data`** - Stores Grafana settings, users, and custom dashboards

These volumes persist even when containers are stopped.

## Network Architecture

```
Internet
   ↓
Supabase API (*.supabase.co)
   ↓
Prometheus (scrapes every 60s)
   ↓
Grafana (visualizes) + Alertmanager (notifies)
   ↓
You (via browser)
```

## Ports

| Service      | Port | Purpose                   |
| ------------ | ---- | ------------------------- |
| Grafana      | 3000 | Web UI for dashboards     |
| Prometheus   | 9090 | Metrics storage and query |
| Alertmanager | 9093 | Alert management          |

## Security Considerations

1. **Secrets Management**
   - Service role key stored in `.env`
   - `.env` excluded from git
   - Environment variables not exposed in logs

2. **Network Security**
   - Services only accessible on localhost by default
   - No external exposure without explicit configuration

3. **Authentication**
   - Grafana requires login (admin user)
   - Prometheus and Alertmanager have no auth (localhost only)

## Customization Points

1. **Alert Thresholds** - Edit `docker/prometheus/rules/supabase-alerts.yml`
2. **Notification Channels** - Edit `docker/alertmanager/alertmanager.yml`
3. **Scrape Interval** - Edit `docker/prometheus/prometheus.yml`
4. **Dashboard Panels** - Customize in Grafana UI
5. **Data Retention** - Add to Prometheus command in `docker-compose.yml`

## Maintenance Tasks

### Daily

- Check Grafana dashboards for anomalies

### Weekly

- Review active alerts
- Check disk usage

### Monthly

- Review and adjust alert thresholds
- Update dashboards if needed

### Quarterly

- Rotate service role key
- Update Docker images
- Review and optimize alert rules
