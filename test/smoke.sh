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
grep -q 'linux-modules-${kernel_release}' "${ROOT_DIR}/guest/private-tunnel-guest"
grep -q '^DRIVER_MODULE=rtw88_8814au$' "${ROOT_DIR}/driver/known-good.env"
grep -q 'Using offline RTL8814AU bundle' "${ROOT_DIR}/private-tunnel"
grep -q 'install_offline_driver_bundle' "${ROOT_DIR}/guest/private-tunnel-guest"
tar -tf "${ROOT_DIR}/driver/offline/rtl8814au-6.17.0-41-generic.tar" | grep -q 'rtw88_8814au.ko.zst$'

(
  cd "${ROOT_DIR}/driver/offline"
  shasum -a 256 -c rtl8814au-6.17.0-41-generic.tar.sha256 >/dev/null
)

printf 'smoke tests passed\n'
