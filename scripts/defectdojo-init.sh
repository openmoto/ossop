#!/bin/bash

# DefectDojo Initialization Script
# This script runs database migrations and creates superuser on first startup

set -e

echo "🚀 DefectDojo Initialization Starting..."

# Wait for database to be ready
echo "⏳ Waiting for database connection..."
until python manage.py migrate --check 2>/dev/null; do
  echo "Waiting for database..."
  sleep 2
done

# Run database migrations
echo "📊 Running database migrations..."
python manage.py migrate --noinput

# Collect static files
echo "📁 Collecting static files..."
python manage.py collectstatic --noinput --clear

# Create superuser if it doesn't exist
echo "👤 Creating superuser..."
python manage.py shell << EOF
import os
from django.contrib.auth.models import User

username = os.environ.get('DD_ADMIN_USER', 'admin')
email = os.environ.get('DD_ADMIN_MAIL', 'admin@defectdojo.local')
password = os.environ.get('DD_ADMIN_PASSWORD', 'admin')

if not User.objects.filter(username=username).exists():
    User.objects.create_superuser(username=username, email=email, password=password)
    print(f"✅ Superuser '{username}' created successfully")
else:
    print(f"ℹ️  Superuser '{username}' already exists")
EOF

echo "✅ DefectDojo initialization completed!"
