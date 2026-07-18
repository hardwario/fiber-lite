#!/usr/bin/env bash
set -euo pipefail

bash <(curl -sL https://github.com/node-red/linux-installers/releases/download/v2.1.1/install-update-nodered-deb) \
  --confirm-root --confirm-install --confirm-pi

sudo systemctl enable nodered.service

SETTINGS="$HOME/.node-red/settings.js"
SECRET="$(openssl rand -hex 32)"
sed -i "s|//credentialSecret:.*|credentialSecret: \"$SECRET\",|" "$SETTINGS"

echo
echo "credentialSecret set in $SETTINGS."
echo
echo "Remaining steps are interactive — the release asset URL above can go stale between"
echo "Node-RED versions, verify it still 200s before trusting this script."
echo
echo "  1. sudo reboot"
echo "  2. node-red admin hash-pw   # enter an admin password when prompted, copy the bcrypt hash"
echo "  3. Edit $SETTINGS — uncomment the adminAuth block and fill in that hash:"
echo '       adminAuth: {'
echo '           type: "credentials",'
echo '           users: [{ username: "admin", password: "<bcrypt hash from step 2>", permissions: "*" }]'
echo '       },'
echo "  4. cd ~/.node-red && npm install node-red-contrib-influxdb"
echo "  5. sudo systemctl restart nodered.service"
echo
echo "Then build the flow described in the docs: MQTT in (application/+/device/+/event/up,"
echo "localhost:1883) -> Function (parse uplink JSON) -> InfluxDB out (token from step 70)."
