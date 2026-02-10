# 🎯 SETUP COMPLETE!

Your Supabase monitoring stack is ready to deploy. Follow these final steps:

## ✅ What's Been Set Up

- ✅ Prometheus configuration with Supabase metrics scraping
- ✅ Grafana with official Supabase dashboard (200+ panels)
- ✅ Alertmanager with 7 pre-configured alert rules
- ✅ Docker Compose orchestration
- ✅ Data persistence volumes
- ✅ Automated provisioning
- ✅ Comprehensive documentation

## 🚀 Next Steps (5 Minutes)

### Step 1: Configure Your Credentials

Open `.env` file and update these values:

```bash
# Your Supabase project reference
SUPABASE_PROJECT_REF=wnejtkpoaiykvbdjhlsu  # ← UPDATE THIS

# Your service role key (starts with eyJ...)
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here  # ← UPDATE THIS

# Grafana admin password
GF_SECURITY_ADMIN_PASSWORD=admin  # ← CHANGE THIS
```

**Where to find your credentials:**

1. **Project Reference:**
   - Look at your Supabase URL: `https://[THIS-PART].supabase.co`
   - Example: `wnejtkpoaiykvbdjhlsu`

2. **Service Role Key:**
   - Go to:
     https://supabase.com/dashboard/project/wnejtkpoaiykvbdjhlsu/settings/api
   - Copy the `service_role` key (the secret one, NOT the anon key)
   - It starts with `eyJ...`

### Step 2: Start the Stack

**Option A: Using the start script (Recommended)**

```bash
# Double-click start.bat
# OR run in terminal:
start.bat
```

**Option B: Using Docker Compose directly**

```bash
docker-compose up -d
```

### Step 3: Verify It's Working

1. **Check services are running:**
   ```bash
   docker-compose ps
   ```
   All services should show "Up"

2. **Check Prometheus is scraping:**
   - Open: http://localhost:9090/targets
   - Look for `supabase_metrics` job
   - Status should be "UP" (may take 1-2 minutes)

3. **Access Grafana:**
   - Open: http://localhost:3000
   - Login: `admin` / `[your password from .env]`
   - Navigate to: Dashboards → Supabase folder
   - You should see metrics flowing in!

## 📊 What You'll See

### Grafana Dashboard Includes:

- **Database Health:** CPU, memory, disk usage
- **Performance:** Query throughput, latency, slow queries
- **Connections:** Active connections, connection pool status
- **Replication:** Replication lag, WAL status
- **Storage:** Database size, table sizes, index bloat
- **Locks:** Lock contention, deadlocks
- **And 200+ more panels!**

### Active Alerts:

| Alert                     | Triggers When             | Severity |
| ------------------------- | ------------------------- | -------- |
| Database Down             | DB unreachable for 5+ min | Critical |
| High Disk Usage           | Disk > 80% full           | Critical |
| Replication Lag           | Lag > 10 minutes          | Warning  |
| High Connections          | Connections > 80          | Warning  |
| Long Transactions         | Transaction > 1 hour      | Warning  |
| Database Growth           | 20%+ growth in 12 hours   | Warning  |
| Too Many Idle Connections | Idle > 50                 | Warning  |

## 🔧 Troubleshooting

### "supabase_metrics" shows DOWN in Prometheus

**Cause:** Authentication or network issue

**Fix:**

1. Verify your service role key is correct in `.env`
2. Ensure your project ref is correct
3. Check you can access: `https://[project-ref].supabase.co`
4. Restart Prometheus: `docker-compose restart prometheus`

### Grafana shows "No Data"

**Cause:** Metrics haven't been scraped yet

**Fix:**

1. Wait 1-2 minutes for initial scrape
2. Check time range in Grafana (top right)
3. Verify Prometheus targets are UP: http://localhost:9090/targets

### Can't login to Grafana

**Cause:** Wrong credentials

**Fix:**

- Username: `admin`
- Password: Check your `.env` file (default is `admin`)
- If forgotten, reset by removing Grafana volume:
  ```bash
  docker-compose down
  docker volume rm fyndr-monitoring_grafana_data
  docker-compose up -d
  ```

## 📚 Documentation

- **Quick Reference:** [QUICKSTART.md](QUICKSTART.md)
- **Full Documentation:** [README.md](README.md)
- **Project Structure:** [STRUCTURE.md](STRUCTURE.md)

## 🎓 Learning Resources

- [Supabase Metrics API Docs](https://supabase.com/docs/guides/telemetry/metrics/grafana-self-hosted)
- [Prometheus Query Language](https://prometheus.io/docs/prometheus/latest/querying/basics/)
- [Grafana Tutorials](https://grafana.com/tutorials/)

## 🔔 Setting Up Notifications (Optional)

To receive alerts via Slack, email, or other channels:

1. Edit `docker/alertmanager/alertmanager.yml`
2. Configure your notification receivers
3. Restart: `docker-compose restart alertmanager`

See [QUICKSTART.md](QUICKSTART.md) for examples.

## 🛡️ Security Checklist

Before deploying to production:

- [ ] Changed Grafana admin password from default
- [ ] Verified `.env` is in `.gitignore`
- [ ] Service role key is kept secret
- [ ] Configured firewall rules (if exposing to internet)
- [ ] Set up SSL/TLS (if exposing to internet)
- [ ] Configured alert notifications
- [ ] Tested alert firing

## 💡 Pro Tips

1. **Bookmark these URLs:**
   - http://localhost:3000 - Grafana dashboards
   - http://localhost:9090/targets - Prometheus targets
   - http://localhost:9090/alerts - Active alerts

2. **Test your alerts:**
   - Temporarily lower thresholds in
     `docker/prometheus/rules/supabase-alerts.yml`
   - Wait for alerts to fire
   - Verify notifications work
   - Restore original thresholds

3. **Create custom views:**
   - Star your favorite dashboard panels
   - Create custom dashboards for your team
   - Set up dashboard playlists for TV displays

4. **Monitor multiple projects:**
   - Add more scrape jobs in `prometheus.yml`
   - Use labels to distinguish projects
   - Create separate dashboards per project

## 🎉 You're All Set!

Your monitoring stack is ready to help you:

- ✅ Track database performance 24/7
- ✅ Get alerted before issues become critical
- ✅ Optimize query performance
- ✅ Plan capacity upgrades
- ✅ Debug production issues faster

**Need help?** Check the documentation files or the Supabase community.

---

**Quick Commands:**

```bash
# Start monitoring
start.bat

# Stop monitoring
stop.bat

# View logs
docker-compose logs -f

# Restart a service
docker-compose restart prometheus
docker-compose restart grafana

# Check status
docker-compose ps
```

Happy monitoring! 📈
