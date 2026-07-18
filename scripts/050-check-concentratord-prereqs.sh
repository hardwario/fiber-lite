#!/usr/bin/env bash
set -euo pipefail

cat <<'BANNER'
=============================================================================
NOT YET VERIFIED ON REAL HARDWARE.

This script only checks prerequisites for the RAK2287 + RAK5146 (SPI)
concentrator — it does not install the SX1302 HAL. Use RAKwireless's own
installer for the RAK2287 on Raspberry Pi (SPI variant, EU868 for European
deployments); see their documentation for the current installer script.

See also: https://docs.hardwario.com/fiber-lite/installation
          #install-chirpstack-concentratord-rak2287--rak5146-spi
=============================================================================
BANNER

if grep -q '^dtparam=spi=on' /boot/firmware/config.txt; then
  echo "SPI enabled in config.txt"
else
  echo "SPI not enabled — add 'dtparam=spi=on' to /boot/firmware/config.txt and reboot."
  exit 1
fi

if ls /dev/spidev* >/dev/null 2>&1; then
  echo "SPI device(s) found: $(ls /dev/spidev*)"
else
  echo "No /dev/spidev* device — RAK2287 HAT not seated/detected. Stopping."
  exit 1
fi

echo
echo "Prerequisites OK. Install RAKwireless's SX1302 HAL for RAK2287 (SPI) manually,"
echo "then continue with 060-install-mqtt-forwarder.sh."
