#!/usr/bin/env bash
# QLI Client — Linux one-click installer (systemd service)
# Uses the official installer: https://dl.qubic.li/cloud-init/qli-Service-install-auto.sh
# Auto-update is enabled. Files are installed under /q.
# Run:  bash install-qli-systemd.sh    (root or sudo required)
set -e

THREADS=0
TOKEN='eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImJiMDIyZGQyLWY4OTUtNDc5Ny1hOWU4LTQyOTZhNjdiZjgwZiIsIk1pbmluZyI6IiIsIm5iZiI6MTc4OTU2MjU4NiwiZXhwIjoxODIxMDk4NTg2LCJpYXQiOjE3ODk1NjI1ODYsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.nqZ203WJn8RYHa8sV_vnkeXiR6OndseZYTvl6nSg9kFJPp-8UjZlkPQItMV_8gADQfjWPOTXDY3dkHt7TVbIvd3f4b7kCwwnHEcoeIRYTULujjZE-Y7k1sJ75eMQEg5Qj2cA4rwQBESdT6QxLlM0O8W_6Kk91oKFLQyS312x1XTF96bCOrCjwauBiElN3c-8vntO-YaFcZraPFrL1S0Ee_TyATBuEL9XHAT6INiTixkasA9cLe1B5uP_dlfDiByxhfB12Ss-lwZOy1mBwOwsAYnOxp-Yrd0vXLsxmYPrZrQbLeh5Bxfjfe-5TLpQYAOOqkoKpQ7nNqB0Ui19NGrgXg'
ALIAS='qli Bat'

if [ "$EUID" -ne 0 ]; then
  echo "This installer needs root privileges (installs a systemd unit)."
  echo "Re-run with: sudo bash $0"
  exit 1
fi

echo "==> Updating apt (safe to skip if it fails)..."
apt update || true

echo "==> Downloading official install script..."
wget -q --show-progress -O /tmp/qli-Service-install.sh \
  https://dl.qubic.li/cloud-init/qli-Service-install-auto.sh
chmod +x /tmp/qli-Service-install.sh

echo "==> Installing qli.service (threads=$THREADS, alias=$ALIAS)..."
/tmp/qli-Service-install.sh "$THREADS" "$TOKEN" "$ALIAS"

echo ""
echo "  Installed as systemd service 'qli'."
echo "  Manage with:"
echo "    systemctl status qli"
echo "    systemctl start qli"
echo "    systemctl stop qli"
echo "    tail -f /var/log/qli.log"
echo ""
echo "  Config file:  /q/appsettings.json"
echo "  To customize further, create /q/appsettings.production.json (won't be overwritten by updates)."
