#!/usr/bin/env python3
import http.server
import json
import os
import time

BASE_DIR = os.path.dirname(os.path.abspath(__file__))


def get_cpu_percent(interval=0.3):
    def read():
        with open('/proc/stat') as f:
            line = f.readline()
        parts = [int(x) for x in line.split()[1:8]]
        idle = parts[3] + parts[4]
        total = sum(parts)
        return idle, total

    idle1, total1 = read()
    time.sleep(interval)
    idle2, total2 = read()
    idle_delta = idle2 - idle1
    total_delta = total2 - total1
    if total_delta <= 0:
        return 0.0
    return round((1 - idle_delta / total_delta) * 100, 1)


def get_mem_percent():
    info = {}
    with open('/proc/meminfo') as f:
        for line in f:
            k, v = line.split(':', 1)
            info[k.strip()] = int(v.strip().split()[0])
    total = info['MemTotal']
    avail = info.get('MemAvailable', info.get('MemFree', 0))
    used = total - avail
    return round(used / total * 100, 1)


def get_disk_percent(path='/'):
    st = os.statvfs(path)
    total = st.f_blocks * st.f_frsize
    free = st.f_bfree * st.f_frsize
    used = total - free
    return round(used / total * 100, 1)


def get_temp_c():
    try:
        with open('/sys/class/thermal/thermal_zone0/temp') as f:
            return round(int(f.read().strip()) / 1000, 1)
    except OSError:
        return None


def get_uptime_str():
    with open('/proc/uptime') as f:
        seconds = float(f.read().split()[0])
    days = int(seconds // 86400)
    hours = int((seconds % 86400) // 3600)
    return f"{days}d {hours:02d}h"


class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=BASE_DIR, **kwargs)

    def do_GET(self):
        if self.path == '/api/stats':
            data = {
                "cpu": get_cpu_percent(),
                "mem": get_mem_percent(),
                "disk": get_disk_percent(),
                "temp": get_temp_c(),
                "uptime": get_uptime_str(),
            }
            body = json.dumps(data).encode()
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Content-Length', str(len(body)))
            self.send_header('Cache-Control', 'no-store')
            self.end_headers()
            self.wfile.write(body)
            return
        super().do_GET()

    def log_message(self, format, *args):
        pass


if __name__ == '__main__':
    server = http.server.ThreadingHTTPServer(('0.0.0.0', 80), Handler)
    server.serve_forever()
