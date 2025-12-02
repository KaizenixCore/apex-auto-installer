#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# 🚀 APEX Auto Installer - Linux Installation Script
# Author: KaizenixCore (Peyman Rasouli)
# ═══════════════════════════════════════════════════════════════

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
echo -e "${PURPLE}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║     🚀 APEX Auto Installer - Linux Edition                ║"
echo "║     Made with ❤️  by KaizenixCore                          ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }

# Check if running as root
check_root() {
    if [ "$EUID" -eq 0 ]; then
        log_warning "Running as root. Consider using a regular user with sudo."
    fi
}

# Detect Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        DISTRO_VERSION=$VERSION_ID
        log_info "Detected: $PRETTY_NAME"
    else
        log_error "Cannot detect Linux distribution"
        exit 1
    fi
}

# Check if Docker is installed
check_docker() {
    log_info "Checking Docker installation..."
    
    if command -v docker &> /dev/null; then
        DOCKER_VERSION=$(docker --version | cut -d' ' -f3 | tr -d ',')
        log_success "Docker is installed (v$DOCKER_VERSION)"
        return 0
    else
        log_warning "Docker is not installed"
        return 1
    fi
}

# Install Docker based on distro
install_docker() {
    log_info "Installing Docker..."
    
    case $DISTRO in
        ubuntu|debian|linuxmint|pop)
            sudo apt-get update
            sudo apt-get install -y docker.io docker-compose
            ;;
        fedora)
            sudo dnf install -y docker docker-compose
            ;;
        centos|rhel|rocky|almalinux)
            sudo yum install -y docker docker-compose
            ;;
        arch|manjaro|endeavouros|garuda)
            sudo pacman -Sy --noconfirm docker docker-compose
            ;;
        opensuse*|sles)
            sudo zypper install -y docker docker-compose
            ;;
        *)
            log_error "Unsupported distribution: $DISTRO"
            log_info "Please install Docker manually: https://docs.docker.com/engine/install/"
            exit 1
            ;;
    esac
    
    # Start and enable Docker
    sudo systemctl start docker
    sudo systemctl enable docker
    
    # Add user to docker group
    sudo usermod -aG docker $USER
    
    log_success "Docker installed successfully!"
    log_warning "Please log out and log back in for group changes to take effect"
}

# Check Docker Compose
check_docker_compose() {
    log_info "Checking Docker Compose..."
    
    if command -v docker-compose &> /dev/null; then
        DC_VERSION=$(docker-compose --version | cut -d' ' -f4 | tr -d ',')
        log_success "Docker Compose is installed (v$DC_VERSION)"
        return 0
    elif docker compose version &> /dev/null; then
        DC_VERSION=$(docker compose version | cut -d' ' -f4)
        log_success "Docker Compose (plugin) is installed (v$DC_VERSION)"
        return 0
    else
        log_warning "Docker Compose is not installed"
        return 1
    fi
}

# Start APEX Stack
start_apex_stack() {
    log_info "Starting Oracle APEX Stack..."
    
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    DOCKER_DIR="$SCRIPT_DIR/../docker"
    
    if [ ! -f "$DOCKER_DIR/docker-compose.yml" ]; then
        log_error "docker-compose.yml not found in $DOCKER_DIR"
        exit 1
    fi
    
    cd "$DOCKER_DIR"
    
    # Check if .env exists
    if [ ! -f ".env" ]; then
        log_warning ".env file not found. Creating from example..."
        cp .env.example .env
        log_info "Please edit docker/.env with your passwords"
    fi
    
    # Start containers
    docker-compose up -d
    
    log_success "APEX Stack is starting!"
    echo ""
    log_info "Waiting for services to be ready..."
    log_info "This may take 2-5 minutes for the first run..."
    echo ""
    log_info "Access APEX at: http://localhost:8080/ords/apex"
    log_info "Workspace: INTERNAL"
    log_info "Username: ADMIN"
}

# Main
main() {
    check_root
    detect_distro
    
    if ! check_docker; then
        read -p "Do you want to install Docker? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_docker
        else
            log_error "Docker is required. Exiting."
            exit 1
        fi
    fi
    
    check_docker_compose
    
    echo ""
    read -p "Do you want to start the APEX stack now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        start_apex_stack
    fi
    
    echo ""
    log_success "Installation complete!"
}

main "$@"
