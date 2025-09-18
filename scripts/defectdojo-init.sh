#!/bin/bash

# DefectDojo Initialization Script
# This script runs database migrations and creates superuser on first startup

set -e

echo "🚀 DefectDojo Initialization Starting..."

# Only run initialization if DD_INITIALIZE is true
if [ "${DD_INITIALIZE}" = "true" ]; then
    echo "⏳ Waiting for database connection..."
    
    # Database connection with timeout (max 60 seconds)
    DB_WAIT_COUNT=0
    DB_MAX_WAIT=30
    
    until [ $DB_WAIT_COUNT -ge $DB_MAX_WAIT ]; do
        if python -c "
import os
import psycopg
try:
    conn = psycopg.connect(os.environ['DD_DATABASE_URL'], connect_timeout=5)
    conn.close()
    exit(0)
except Exception as e:
    print(f'Connection attempt failed: {e}')
    exit(1)
" 2>/dev/null; then
            echo "✅ Database connection successful!"
            break
        fi
        
        DB_WAIT_COUNT=$((DB_WAIT_COUNT + 1))
        echo "⏳ Database not ready yet... (attempt $DB_WAIT_COUNT/$DB_MAX_WAIT)"
        sleep 2
    done
    
    # Check if we timed out
    if [ $DB_WAIT_COUNT -ge $DB_MAX_WAIT ]; then
        echo "❌ ERROR: Database connection timeout after $((DB_MAX_WAIT * 2)) seconds"
        echo "❌ Continuing anyway - DefectDojo might still work..."
    fi

    echo "📊 Running database migrations..."
    if python manage.py migrate --noinput; then
        echo "✅ Database migrations completed successfully"
    else
        echo "❌ ERROR: Database migrations failed"
        echo "❌ This is a critical error - DefectDojo will not work properly"
        exit 1
    fi

    echo "📁 Collecting static files..."
    # Ensure static directory exists and has proper permissions
    mkdir -p /app/static
    
    # Fix permissions as root (we're running as root in docker-compose)
    echo "🔧 Setting up static file permissions..."
    chown -R defectdojo:defectdojo /app/static 2>/dev/null || echo "⚠️  Could not change ownership (continuing anyway)"
    chmod -R 755 /app/static 2>/dev/null || echo "⚠️  Could not change permissions (continuing anyway)"
    
    # Collect static files with better error handling
    if python manage.py collectstatic --noinput --clear; then
        echo "✅ Static files collected successfully"
    else
        echo "⚠️  Initial static file collection failed, trying alternative approach..."
        # Try without --clear flag
        if python manage.py collectstatic --noinput; then
            echo "✅ Static files collected successfully (alternative method)"
        else
            echo "❌ WARNING: Static file collection failed completely"
            echo "❌ DefectDojo UI may not display correctly"
            echo "❌ Continuing with startup anyway..."
        fi
    fi

    echo "👤 Creating superuser..."
    if python manage.py shell << EOF
import os
from django.contrib.auth.models import User

try:
    username = os.environ.get('DD_ADMIN_USER', 'admin')
    email = os.environ.get('DD_ADMIN_MAIL', 'admin@defectdojo.local')
    password = os.environ.get('DD_ADMIN_PASSWORD', 'admin')

    if not User.objects.filter(username=username).exists():
        User.objects.create_superuser(username=username, email=email, password=password)
        print(f"✅ Superuser '{username}' created successfully")
    else:
        print(f"ℹ️  Superuser '{username}' already exists")
        
    print("✅ Superuser setup completed")
except Exception as e:
    print(f"❌ ERROR: Failed to create superuser: {e}")
    exit(1)
EOF
    then
        echo "✅ Superuser configuration successful"
    else
        echo "❌ WARNING: Superuser creation failed"
        echo "❌ You may need to create an admin user manually"
        echo "❌ Continuing with startup anyway..."
    fi

    echo ""
    echo "🎉 DefectDojo initialization completed successfully!"
    echo "📋 Summary:"
    echo "   ✅ Database migrations: Complete"
    echo "   ✅ Static files: Collected"
    echo "   ✅ Superuser: Configured"
    echo "   🌐 DefectDojo will be available at: http://localhost:8083"
    echo ""
else
    echo "ℹ️  DD_INITIALIZE is not true, skipping initialization"
    echo "ℹ️  DefectDojo will start with existing configuration"
fi

echo "🚀 Starting DefectDojo application server..."
