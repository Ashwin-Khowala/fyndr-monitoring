#!/bin/bash

# Supabase Monitoring Stack - Quick Start Script

echo "🚀 Starting Supabase Monitoring Stack..."
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found!"
    echo "📝 Please copy .env.example to .env and configure your credentials:"
    echo "   cp .env.example .env"
    echo "   Then edit .env with your Supabase project details"
    exit 1
fi

# Check if required environment variables are set
source .env

if [ -z "$SUPABASE_SERVICE_ROLE_KEY" ] || [ "$SUPABASE_SERVICE_ROLE_KEY" = "your_service_role_key_here" ]; then
    echo "❌ Error: SUPABASE_SERVICE_ROLE_KEY not configured in .env"
    echo "📝 Please edit .env and set your Supabase service role key"
    exit 1
fi

if [ -z "$SUPABASE_PROJECT_REF" ]; then
    echo "❌ Error: SUPABASE_PROJECT_REF not configured in .env"
    echo "📝 Please edit .env and set your Supabase project reference"
    exit 1
fi

echo "✅ Configuration validated"
echo ""

# Start the stack
echo "🐳 Starting Docker containers..."
docker-compose up -d

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Monitoring stack started successfully!"
    echo ""
    echo "📊 Access your monitoring tools:"
    echo "   • Grafana:      http://localhost:3000 (admin / ${GF_SECURITY_ADMIN_PASSWORD:-admin})"
    echo "   • Prometheus:   http://localhost:9090"
    echo "   • Alertmanager: http://localhost:9093"
    echo ""
    echo "⏳ Waiting for services to be ready..."
    sleep 5
    
    # Check if services are healthy
    echo ""
    echo "🔍 Checking service status..."
    docker-compose ps
    
    echo ""
    echo "📈 Next steps:"
    echo "   1. Open Grafana at http://localhost:3000"
    echo "   2. Login with admin / ${GF_SECURITY_ADMIN_PASSWORD:-admin}"
    echo "   3. Navigate to Dashboards → Supabase folder"
    echo "   4. Check Prometheus targets at http://localhost:9090/targets"
    echo ""
    echo "📖 For more information, see README.md"
else
    echo ""
    echo "❌ Failed to start monitoring stack"
    echo "📝 Check the error messages above and try again"
    exit 1
fi
