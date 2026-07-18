#!/usr/bin/env bash
set -euo pipefail

sudo apt install -y i2c-tools util-linux-extra
echo 'i2c-dev' | sudo tee -a /etc/modules-load.d/i2c.conf > /dev/null

cat << 'EOF' | sudo tee -a /boot/firmware/config.txt > /dev/null
dtparam=i2c_arm=on
dtparam=i2c_vc=on
disable_poe_fan=1
force_eeprom_read=0
camera_auto_detect=0
EOF

echo
echo "Hardware configured."
echo "NOTE: FIBER Lite (Raspberry Pi 5) has a built-in RTC — do NOT add an external"
echo "dtoverlay=i2c-rtc,pcf85063a line here (that's only for the CM4-based FIBER)."
echo
echo "Reboot before continuing: sudo reboot"
