#!/bin/bash

set -e

########################################
# Constants
########################################

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
NGINX_CONF="$REPO_ROOT/install/nginx/git.conf"
FCGI_SERVICE="$REPO_ROOT/install/systemd/fcgiwrap.service"
echo "======================================"
echo " Git Smart HTTP Server Installer"
echo "======================================"

########################################
# Root check
########################################

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

########################################
# Functions
########################################

install_packages() {
    echo "[1/4] Installing packages..."

    apt update
    apt install -y git nginx fcgiwrap

    echo "Done."
}

create_git_user() {
    echo "[2/4] Creating git user..."

    if id git >/dev/null 2>&1; then
        echo "git user already exists."
    else
        adduser --system --group --home /srv/git git
        echo "git user created."
    fi
}

create_git_root() {
    echo "[3/4] Creating repository root..."

    mkdir -p /srv/git

    chown git:git /srv/git
    chmod 755 /srv/git

    echo "/srv/git ready."
}

install_nginx_config() {

    echo "[4/7] Installing Nginx configuration..."

    if [ ! -f "$NGINX_CONF" ]; then
        echo "Error: $NGINX_CONF not found."
        exit 1
    fi

    cp "$NGINX_CONF" /etc/nginx/sites-available/git

    ln -sf /etc/nginx/sites-available/git \
           /etc/nginx/sites-enabled/git

    nginx -t

    echo "Nginx configuration installed."
}

# finish() {
#     echo
#     echo "[4/4] Base installation complete."
#     echo
#     echo "Next:"
#     echo "  - Configure Nginx"
#     echo "  - Configure fcgiwrap"
#     echo "  - Run verification"
# }
install_fcgiwrap_service() {

    echo "[5/7] Installing fcgiwrap service..."

    if [ ! -f "$FCGI_SERVICE" ]; then
        echo "Error: $FCGI_SERVICE not found."
        exit 1
    fi

    cp "$FCGI_SERVICE" /etc/systemd/system/fcgiwrap.service

    systemctl daemon-reload

    echo "fcgiwrap service installed."
}
restart_services() {

    echo "[6/7] Restarting services..."

    systemctl enable nginx
    systemctl enable fcgiwrap

    systemctl restart fcgiwrap
    systemctl restart nginx

    echo "Services restarted."
}
verify_services() {

    echo "[7/7] Verifying installation..."

    systemctl is-active --quiet nginx
    echo "✓ nginx running"

    systemctl is-active --quiet fcgiwrap
    echo "✓ fcgiwrap running"

    if [ -x /usr/lib/git-core/git-http-backend ]; then
    echo "✓ git-http-backend found"
    else
    echo "✗ git-http-backend not found"
        exit 1
    fi
}
########################################
# Main
########################################

main() {
    install_packages
    create_git_user
    create_git_root
    install_nginx_config
    install_fcgiwrap_service
    restart_services
    echo
    echo "Running verification..."
    echo

    "$REPO_ROOT/install/scripts/verify.sh"
}

main