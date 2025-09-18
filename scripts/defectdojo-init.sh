#!/bin/bash

# DefectDojo Initialization Script
# This script runs database migrations and creates superuser on first startup

set -e

echo "🚀 DefectDojo Initialization Starting..."

# Only run initialization if DD_INITIALIZE is true
if [ "${DD_INITIALIZE}" = "true" ]; then
    echo "⏳ Waiting for database connection..."
    until python manage.py migrate --check 2>/dev/null; do
        echo "Waiting for database..."
        sleep 2
    done

    echo "📊 Running database migrations..."
    python manage.py migrate --noinput

    echo "📁 Collecting static files..."
    # Ensure static directory exists and has proper permissions
    mkdir -p /app/static
    # Try to fix permissions, ignore errors if not root
    chown -R defectdojo:defectdojo /app/static 2>/dev/null || true
    chmod -R 755 /app/static 2>/dev/null || true
    python manage.py collectstatic --noinput --clear

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
else
    echo "ℹ️  DD_INITIALIZE is not true, skipping initialization"
fi
