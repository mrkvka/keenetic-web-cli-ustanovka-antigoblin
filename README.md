# Opengater Keenetic AntiGoblin Installer

Install AntiGoblin on Keenetic after the official Entware installer, without asking the user to open SSH.

The user still installs Entware with the official Keenetic/Entware command. AntiGoblin is then installed from Keenetic Web CLI with `exec sh -c`.

## User Flow

Open Keenetic Web CLI:

```text
http://192.168.1.1/a
```

Run the official Entware installer:

```sh
opkg disk OPKG:/ https://bin.entware.net/aarch64-k3.10/installer/aarch64-installer.tar.gz
```

Then run:

```sh
opkg initrc /opt/etc/init.d/rc.unslung
```

Then run:

```sh
system configuration save
```

Then reboot:

```sh
system reboot
```

Wait 2-5 minutes after reboot. Then open Web CLI again:

```text
http://192.168.1.1/a
```

Install AntiGoblin through Entware shell:

```sh
exec sh -c "/opt/bin/wget -O - https://raw.githubusercontent.com/opengater/opengater-keenetic-antigoblin-installer/main/install.sh | /opt/bin/sh"
```

After installation, open:

```text
http://192.168.1.1:8899/
```

## What This Wrapper Does

`install.sh` runs inside Entware and:

- verifies that `/opt/bin/opkg`, `/opt/bin/wget`, and `/opt/bin/sh` exist;
- runs `opkg update`;
- installs basic download/archive prerequisites if missing;
- downloads the upstream AntiGoblin installer;
- runs the upstream installer with `/opt/bin/sh`;
- writes progress to stdout and the Keenetic system log with the tag `opengater-antigoblin`.

## Why Not Custom Entware Installer

This repository intentionally does not modify `aarch64-installer.tar.gz`.

Entware stays official:

```text
https://bin.entware.net/aarch64-k3.10/installer/aarch64-installer.tar.gz
```

Only AntiGoblin is installed by this wrapper after Entware is already mounted and working.

## Manual Test

Run syntax checks locally:

```sh
sh -n install.sh
```

On a Keenetic device with Entware installed, run from Web CLI:

```sh
exec sh -c "/opt/bin/wget -O - https://raw.githubusercontent.com/opengater/opengater-keenetic-antigoblin-installer/main/install.sh | /opt/bin/sh"
```

If `exec sh -c` is unavailable in a specific KeeneticOS build, SSH is the fallback. The whole point of this wrapper is to keep the normal path inside Web CLI.
