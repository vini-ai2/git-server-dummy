#!/bin/bash

set -e

echo "======================================"
echo " Git Smart HTTP Server Verification"
echo "======================================"

echo "[1/6] Checking required software..."

command -v git >/dev/null
echo "✓ git installed"

command -v nginx >/dev/null
echo "✓ nginx installed"

command -v fcgiwrap >/dev/null
echo "✓ fcgiwrap installed"

echo
echo "[2/6] Checking git-http-backend..."

if [ -x /usr/lib/git-core/git-http-backend ]; then
    echo "✓ git-http-backend found"
else
    echo "✗ git-http-backend not found"
    exit 1
fi

echo
echo "[3/6] Checking git user..."

if id git >/dev/null 2>&1; then
    echo "✓ git user exists"
else
    echo "✗ git user missing"
    exit 1
fi

echo
echo "[4/6] Checking repository root..."

if [ -d /srv/git ]; then
    echo "✓ /srv/git exists"
else
    echo "✗ /srv/git missing"
    exit 1
fi

echo
echo "[5/6] Checking services..."

systemctl is-active --quiet nginx
echo "✓ nginx running"

systemctl is-active --quiet fcgiwrap
echo "✓ fcgiwrap running"

echo
echo "[6/6] Validating Nginx configuration..."

nginx -t >/dev/null
echo "✓ nginx configuration valid"

echo
echo "======================================"
echo "Verification completed successfully."
echo "======================================"