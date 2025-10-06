@echo off
REM OSSOP - Open Source Security Operations Platform
REM Automated Setup Script for Windows
REM This script sets up OSSOP with minimal user interaction

echo 🛡️  OSSOP - Open Source Security Operations Platform
echo ==================================================
echo.

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not installed. Please install Docker Desktop first:
    echo    Download from: https://docker.com/products/docker-desktop
    echo    After installation, restart this script.
    pause
    exit /b 1
)

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not running. Please start Docker Desktop first.
    pause
    exit /b 1
)

echo ✅ Docker is installed and running
echo.

REM Check if Docker Compose is available
docker compose version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Compose is not available. Please update Docker Desktop.
    pause
    exit /b 1
)

echo ✅ Docker Compose is available
echo.

REM Create .env file if it doesn't exist
if not exist .env (
    echo 📝 Creating .env file from template...
    copy .env.example .env >nul
    echo ✅ .env file created
) else (
    echo ✅ .env file already exists
)
echo.

REM Build SpiderFoot (required)
echo 🔨 Building SpiderFoot (this may take 5-10 minutes)...
docker compose build spiderfoot
if %errorlevel% neq 0 (
    echo ❌ Failed to build SpiderFoot. Please check your internet connection.
    pause
    exit /b 1
)
echo ✅ SpiderFoot built successfully
echo.

REM Start all services
echo 🚀 Starting OSSOP services...
docker compose up -d
if %errorlevel% neq 0 (
    echo ❌ Failed to start services. Please check the error messages above.
    pause
    exit /b 1
)

echo.
echo ⏳ Waiting for services to initialize (this may take 3-5 minutes)...
timeout /t 30 /nobreak >nul

REM Check service status
echo.
echo 📊 Checking service status...
docker compose ps --format "table {{.Name}}\t{{.Status}}"

echo.
echo 🎉 OSSOP is starting up!
echo.
echo 🌐 Access your security tools:
echo    • OpenSearch Dashboards: http://localhost:5601
echo    • DefectDojo:           http://localhost:8083 (admin/admin)
echo    • MISP:                 http://localhost:8082 (admin@admin.test/admin)
echo    • Shuffle:              http://localhost:80
echo    • IRIS:                 http://localhost:8080 (check logs for password)
echo    • SpiderFoot:           http://localhost:5002 (admin/admin)
echo    • Eramba:               http://localhost:8081 (admin/admin)
echo    • Gophish:              http://localhost:3333 (admin/check logs)
echo.
echo 📋 Next steps:
echo    1. Wait 3-5 minutes for all services to fully start
echo    2. Check service status: docker compose ps
echo    3. View logs if needed: docker compose logs [service-name]
echo    4. Change default passwords in each tool
echo    5. Configure integrations between services
echo.
echo 📚 Documentation: https://github.com/openmoto/ossop/tree/main/docs
echo.
echo 🆘 Need help? Check the troubleshooting guide in docs/SETUP.md
echo.
echo Happy security hunting! 🕵️‍♂️
echo.
pause
