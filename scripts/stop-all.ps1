$ErrorActionPreference = "Continue"

$appsDir = "apps"
$rootDir = Resolve-Path "$PSScriptRoot/.."

function Stop-App {
    param($appName)
    $composeFile = Join-Path $rootDir "$appsDir\$appName\docker-compose.yml"
    if (Test-Path $composeFile) {
        Write-Host "Stopping $appName..." -ForegroundColor Cyan
        docker compose -f $composeFile down
    } else {
        Write-Host "Error: Compose file for $appName not found at $composeFile" -ForegroundColor Red
    }
}

# Stop reverse order roughly
Stop-App "gophish"
Stop-App "suricata"
Stop-App "eramba"
Stop-App "spiderfoot"
Stop-App "misp"
Stop-App "defectdojo"
Stop-App "iris"
Stop-App "shuffle"
Stop-App "wazuh"
Stop-App "opensearch"

Write-Host "All apps stopped." -ForegroundColor Green
