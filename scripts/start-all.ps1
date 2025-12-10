$ErrorActionPreference = "Continue"

# Resolve root relative to script location
$rootDir = Resolve-Path "$PSScriptRoot/.."
Set-Location $rootDir

# Create network
Write-Host "Creating network ossop-network..."
docker network create ossop-network 2>$null

# Create volumes (explicitly named to match compose external:true)
$volumes = @(
    "ossop_opensearch_data",
    "ossop_shuffle_db_data",
    "ossop_iris_db_data",
    "ossop_defectdojo_db_data",
    "ossop_misp_db_data",
    "ossop_misp_redis_data"
)

foreach ($vol in $volumes) {
    if (-not (docker volume ls -q -f name=$vol)) {
        Write-Host "Creating volume $vol..." -ForegroundColor Gray
        docker volume create $vol | Out-Null
    }
}

$appsDir = "apps"

function Start-App {
    param($appName)
    # Use relative paths with forward slashes for Docker compatibility
    $composeFile = "./$appsDir/$appName/docker-compose.yml"
    if (Test-Path $composeFile) {
        Write-Host "Starting $appName from $composeFile..." -ForegroundColor Cyan
        # Pass env file explicitly to ensure variables are loaded
        # Using relative .env from root
        docker compose -f $composeFile --env-file ./.env up -d --remove-orphans
    }
    else {
        Write-Host "Error: Compose file for $appName not found at $composeFile" -ForegroundColor Red
    }
}

# Start Core First
Start-App "opensearch"
Write-Host "Waiting 20 seconds for OpenSearch to initialize..." -ForegroundColor Yellow
Start-Sleep -Seconds 20

# Start Dependents
Start-App "wazuh"
Start-App "shuffle"
Start-App "iris"
Start-App "defectdojo"
Start-App "misp"
Start-App "spiderfoot"
Start-App "eramba"
Start-App "suricata"
Start-App "gophish"

Write-Host "All apps have been requested to start." -ForegroundColor Green
Write-Host "Run 'docker compose -f apps/<app>/docker-compose.yml logs -f' to monitor specific apps."
