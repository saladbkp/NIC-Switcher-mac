#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash -n "${ROOT_DIR}/private-tunnel"
bash -n "${ROOT_DIR}/guest/private-tunnel-guest"
bash -n "${ROOT_DIR}/connect"
"${ROOT_DIR}/private-tunnel" help >/dev/null

grep -q '^TARGET_CIDR=$' "${ROOT_DIR}/config.env.example"
grep -q '^WIFI_SSID=$' "${ROOT_DIR}/config.env.example"
grep -q 'guest_action scan' "${ROOT_DIR}/private-tunnel"
grep -q 'connect --list' "${ROOT_DIR}/private-tunnel"
grep -q 'admin_wg_quick up' "${ROOT_DIR}/private-tunnel"
grep -q 'LIMA_PRIVATE_NAT' "${ROOT_DIR}/guest/private-tunnel-guest"
grep -q 'UseRoutes=no' "${ROOT_DIR}/guest/private-tunnel-guest"
grep -q 'UseDNS=no' "${ROOT_DIR}/guest/private-tunnel-guest"

printf 'smoke tests passed\n'
