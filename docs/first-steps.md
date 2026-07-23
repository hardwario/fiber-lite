# FIBER Lite Quick Start Guide

Thank you for choosing FIBER Lite.

Follow these steps to flash it, install the software, and see your first LoRaWAN device join.

For more detailed information, see [**Installation**](installation.md) for the full walkthrough
and [**Introduction**](introduction.md) for the architecture and data flow.

---

## Step 1: Flash and Boot the Raspberry Pi 5

1. Flash Raspberry Pi OS Lite (64-bit) with Raspberry Pi Imager, setting a hostname,
   username/password, and enabling SSH in the Customisation step — see
   [Flash Raspberry Pi OS](installation.md#flash-raspberry-pi-os) for the full walkthrough with
   screenshots.
2. Insert the card, power on, find the device's IP address, and SSH in:

   ```sh
   ssh fiberlite@<TARGET IP ADDRESS>
   ```

> [!TIP]
> If SSH refuses the connection outright, or accepts one but rejects every password, those are
> both known first-boot gotchas with quick fixes — see
> [Troubleshooting](troubleshooting/).

---

## Step 2: Clone the Repo and Run the Install Scripts

```sh
git clone https://github.com/hardwario/fiber-lite.git
cd fiber-lite
```

Run the numbered scripts in `scripts/` **in order** — each is short and readable, and several
prompt for a password or require a reboot before continuing (see
[Installation](installation.md) for what each one does and any manual steps it prints):

```sh
./scripts/010-update-system.sh
./scripts/020-configure-hardware.sh
./scripts/030-install-docker.sh
./scripts/040-install-chirpstack.sh
./scripts/050-check-concentratord-prereqs.sh
./scripts/060-install-mqtt-forwarder.sh
./scripts/070-install-influxdb.sh
./scripts/080-install-nodered.sh
./scripts/090-install-grafana.sh
./scripts/100-install-dashboard.sh
./scripts/110-firewall.sh
```

---

## Step 3: Register a Gateway and a Device

Nothing joins the network until a gateway and a device are registered in ChirpStack — this part
isn't scriptable (ChirpStack has no CLI for it). See
[Register a Gateway and a Device](installation.md#register-a-gateway-and-a-device) for the full
UI walkthrough: add the gateway using the ID from the Concentratord logs, create a device
profile and application, then add your STICKER or CHESTER's DevEUI and OTAA keys.

> [!WARNING]
> The RAK2287 + RAK5146 SPI concentrator this step depends on is **not yet verified on real
> hardware** — treat the concentrator install steps as a documented starting point, not a
> guaranteed working procedure.

---

## Step 4: Power On Your Test Device

Power on the physical LoRaWAN device (your STICKER or CHESTER). Watch ChirpStack's **LoRaWAN
frames** tab (live view) for the device — a join-request followed by a join-accept should
appear within seconds if the gateway is in range and everything above is configured correctly.

### Concentrator Troubleshooting

If nothing appears at all, check the gateway's **Last seen at** timestamp first — no traffic
reaching the gateway means the problem is on the radio/concentrator side, not the device
registration. See [Troubleshooting](troubleshooting/) and the concentrator section of
[Installation](installation.md#install-chirpstack-concentratord-rak2287--rak5146-spi).

---

## Step 5: Access Your Dashboard and Services

| Service | URL |
|---|---|
| Dashboard | `http://[TARGET IP ADDRESS]/` |
| ChirpStack | `http://[TARGET IP ADDRESS]:8080/` |
| Node-RED | `http://[TARGET IP ADDRESS]:1880/` |
| InfluxDB | `http://[TARGET IP ADDRESS]:8086/` |
| Grafana | `http://[TARGET IP ADDRESS]:3000/` |

The dashboard links to every other service and shows live system stats, so it's the easiest
starting point. Full default-credentials table:
[Ports & Default Credentials](installation.md#ports--default-credentials).

---

## Step 6: Configure and Extend

Once ChirpStack is receiving uplinks from your test device:

- **Build the Node-RED flow** (MQTT in → Function → InfluxDB out) if you haven't already —
  see [Install Node-RED](installation.md#install-node-red).
- **Build Grafana dashboard panels** now that there's real data to visualize — see
  [Install Grafana](installation.md#install-grafana).

> [!WARNING]
> Change **ChirpStack's default `admin`/`admin` login** before exposing the device on any
> shared network — nothing in the install scripts rotates it automatically.

---

✅ **That's it!**
Your FIBER Lite is flashed, running the full stack, and receiving real LoRaWAN uplinks.

---

## Step 7: Troubleshooting and Further Reading

If anything along the way didn't behave as expected:

- [SSH Connection Refused](troubleshooting/ssh-connection-refused.md)
- [SSH Permission Denied](troubleshooting/ssh-permission-denied.md)
- [Docker Compose Plugin Not Found](troubleshooting/docker-compose-plugin-not-found.md)
- [Node-RED Installer 404](troubleshooting/nodered-installer-404.md)
- [RTC -EREMOTEIO Error](troubleshooting/rtc-remoteio-error.md)

For the complete step-by-step with screenshots and every command, see
[**Installation**](installation.md).
