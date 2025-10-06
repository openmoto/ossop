#!/bin/bash

# OSSOP - Open Source Security Operations Platform
# Automated Setup Script
# This script sets up OSSOP with minimal user interaction

set -e  # Exit on any error

echo "🛡️  OSSOP - Open Source Security Operations Platform"
echo "=================================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first:"
    echo "   Ubuntu/Debian: curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh"
    echo "   CentOS/RHEL: sudo yum install -y docker-ce docker-ce-cli containerd.io"
    echo "   Windows: Download from https://docker.com/products/docker-desktop"
    echo "   macOS: Download from https://docker.com/products/docker-desktop"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

echo "✅ Docker is installed and running"
echo ""

# Check system requirements
echo "🔍 Checking system requirements..."

# Check available disk space (need at least 50GB)
AVAILABLE_SPACE=$(df . | tail -1 | awk '{print $4}')
REQUIRED_SPACE=52428800  # 50GB in KB

if [ "$AVAILABLE_SPACE" -lt "$REQUIRED_SPACE" ]; then
    echo "⚠️  Warning: Low disk space. OSSOP requires at least 50GB free space."
    echo "   Available: $(($AVAILABLE_SPACE / 1024 / 1024))GB"
    echo "   Required: 50GB"
    echo ""
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check available memory (need at least 8GB)
TOTAL_MEM=$(free -m | awk 'NR==2{print $2}')
if [ "$TOTAL_MEM" -lt 8192 ]; then
    echo "⚠️  Warning: Low memory. OSSOP requires at least 8GB RAM."
    echo "   Available: ${TOTAL_MEM}MB"
    echo "   Required: 8192MB"
    echo ""
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "✅ System requirements check passed"
echo ""

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file from template..."
    cp .env.example .env
    echo "✅ .env file created"
else
    echo "✅ .env file already exists"
fi
echo ""

# Build SpiderFoot (required)
echo "🔨 Building SpiderFoot (this may take 5-10 minutes)..."
docker compose build spiderfoot
echo "✅ SpiderFoot built successfully"
echo ""

# Start all services
echo "🚀 Starting OSSOP services..."
docker compose up -d

echo ""
echo "⏳ Waiting for services to initialize (this may take 3-5 minutes)..."
sleep 30

# Check service status
echo ""
echo "📊 Checking service status..."
docker compose ps --format "table {{.Name}}\t{{.Status}}"

echo ""
echo "🎉 OSSOP is starting up!"
echo ""
echo "🌐 Access your security tools:"
echo "   • OpenSearch Dashboards: http://localhost:5601"
echo "   • DefectDojo:           http://localhost:8083 (admin/admin)"
echo "   • MISP:                 http://localhost:8082 (admin@admin.test/admin)"
echo "   • Shuffle:              http://localhost:80"
echo "   • IRIS:                 http://localhost:8080 (check logs for password)"
echo "   • SpiderFoot:           http://localhost:5002 (admin/admin)"
echo "   • Eramba:               http://localhost:8081 (admin/admin)"
echo "   • Gophish:              http://localhost:3333 (admin/check logs)"
echo ""
echo "📋 Next steps:"
echo "   1. Wait 3-5 minutes for all services to fully start"
echo "   2. Check service status: docker compose ps"
echo "   3. View logs if needed: docker compose logs [service-name]"
echo "   4. Change default passwords in each tool"
echo "   5. Configure integrations between services"
echo ""
echo "📚 Documentation: https://github.com/openmoto/ossop/tree/main/docs"
echo ""
echo "🆘 Need help? Check the troubleshooting guide in docs/SETUP.md"
echo ""
echo "Happy security hunting! 🕵️‍♂️"
