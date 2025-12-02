# ═══════════════════════════════════════════════════════════════
# 🚀 APEX Auto Installer - Windows Installation Script
# Author: KaizenixCore (Peyman Rasouli)
# ═══════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

# Colors function
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) { Write-Output $args }
    $host.UI.RawUI.ForegroundColor = $fc
}

# Banner
Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║     🚀 APEX Auto Installer - Windows Edition              ║" -ForegroundColor Magenta
Write-Host "║     Made with ❤️  by KaizenixCore                          ║" -ForegroundColor Magenta
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""

# Check if Docker Desktop is installed
function Check-Docker {
    Write-Host "[INFO] Checking Docker installation..." -ForegroundColor Cyan
    
    try {
        $dockerVersion = docker --version
        Write-Host "[✓] $dockerVersion" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "[!] Docker is not installed or not in PATH" -ForegroundColor Yellow
        return $false
    }
}

# Check Docker Compose
function Check-DockerCompose {
    Write-Host "[INFO] Checking Docker Compose..." -ForegroundColor Cyan
    
    try {
        $composeVersion = docker compose version
        Write-Host "[✓] $composeVersion" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "[!] Docker Compose not available" -ForegroundColor Yellow
        return $false
    }
}

# Start APEX Stack
function Start-ApexStack {
    Write-Host "[INFO] Starting Oracle APEX Stack..." -ForegroundColor Cyan
    
    $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
    $dockerPath = Join-Path $scriptPath "..\docker"
    
    if (-not (Test-Path "$dockerPath\docker-compose.yml")) {
        Write-Host "[✗] docker-compose.yml not found!" -ForegroundColor Red
        exit 1
    }
    
    Set-Location $dockerPath
    
    # Check .env
    if (-not (Test-Path ".env")) {
        Write-Host "[!] .env not found. Creating from example..." -ForegroundColor Yellow
        Copy-Item ".env.example" ".env"
        Write-Host "[INFO] Please edit docker\.env with your passwords" -ForegroundColor Cyan
    }
    
    # Start containers
    docker compose up -d
    
    Write-Host ""
    Write-Host "[✓] APEX Stack is starting!" -ForegroundColor Green
    Write-Host ""
    Write-Host "[INFO] Waiting for services to be ready..." -ForegroundColor Cyan
    Write-Host "[INFO] This may take 2-5 minutes for the first run..." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "[INFO] Access APEX at: http://localhost:8080/ords/apex" -ForegroundColor Green
    Write-Host "[INFO] Workspace: INTERNAL" -ForegroundColor Green
    Write-Host "[INFO] Username: ADMIN" -ForegroundColor Green
}

# Main
function Main {
    if (-not (Check-Docker)) {
        Write-Host ""
        Write-Host "Docker Desktop is required!" -ForegroundColor Red
        Write-Host "Download from: https://www.docker.com/products/docker-desktop/" -ForegroundColor Yellow
        Write-Host ""
        exit 1
    }
    
    Check-DockerCompose
    
    Write-Host ""
    $response = Read-Host "Do you want to start the APEX stack now? (y/n)"
    
    if ($response -eq 'y' -or $response -eq 'Y') {
        Start-ApexStack
    }
    
    Write-Host ""
    Write-Host "[✓] Setup complete!" -ForegroundColor Green
}

Main
