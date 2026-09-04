# NIC-Switcher-mac

A small macOS CLI that keeps the Mac on its normal Wi-Fi while a USB Wi-Fi adapter connects to a separate private network through a Lima Linux VM. Only the private IPv4 host or CIDR you choose is sent through the tunnel.

Use it only on networks and systems you own or are authorized to test.

## Architecture

```text
Internet traffic  -> macOS built-in Wi-Fi
Private IPv4 CIDR -> WireGuard utun -> Lima/QEMU -> USB Wi-Fi
```

The USB adapter is passed to Linux because macOS does not expose it as a second native Wi-Fi interface. Wi-Fi passwords are requested when connecting and are never saved.

`setup` first uses a matching bundle from `driver/offline/`. If the kernel version does not match, it falls back to installing the Ubuntu driver package online. Known-good metadata and checksums are kept in `driver/known-good.env`.

## Requirements

- macOS with Homebrew
- Lima 2 with a QEMU x86_64 instance (default: `linux`)
- A Linux-supported USB Wi-Fi adapter

```bash
brew install qemu wireguard-tools
./private-tunnel doctor
./private-tunnel setup
```

## Usage

First connection, or to choose another network:

```bash
./private-tunnel connect --list
```

The command scans nearby networks, asks which one to use, prompts for the private IPv4 host or CIDR, and then asks for the Wi-Fi password.

```bash
./private-tunnel connect   # Reconnect with the saved network and CIDR
./private-tunnel status    # Show tunnel status
./private-tunnel stop      # Disconnect and release the USB adapter
./private-tunnel forget    # Remove the saved local profile
```

The selected SSID and CIDR are stored locally under `.state/`, which is excluded from git. Prefer a `/32` CIDR when only one private host is required.
