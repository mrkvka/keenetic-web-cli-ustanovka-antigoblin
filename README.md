# Opengater Keenetic AntiGoblin Installer

Web CLI installation flow for Keenetic Hopper KN-3811:

- Entware is installed with the official Keenetic/Entware `opkg disk` command.
- AntiGoblin is installed with the Opengater wrapper command.
- The user does not need SSH for the normal path.

The important limitation: `install.sh` cannot install Entware by itself, because it runs inside Entware. Before `opkg disk` finishes, `/opt/bin/sh`, `/opt/bin/wget`, and `/opt/bin/opkg` do not exist yet.

## User Flow

Open Keenetic Web CLI:

```text
http://192.168.1.1/a
```

### 1. Install official Entware

```sh
opkg disk OPKG:/ https://bin.entware.net/aarch64-k3.10/installer/aarch64-installer.tar.gz
```

### 2. Set Entware initrc

```sh
opkg initrc /opt/etc/init.d/rc.unslung
```

### 3. Save Keenetic configuration

```sh
system configuration save
```

### 4. Reboot

```sh
system reboot
```

Wait 2-5 minutes after reboot. Then open Web CLI again:

```text
http://192.168.1.1/a
```

### 5. Install AntiGoblin through Web CLI

```sh
exec sh -c "/opt/bin/wget -O - https://raw.githubusercontent.com/opengater/opengater-keenetic-antigoblin-installer/main/install.sh | /opt/bin/sh"
```

After installation, open:

```text
http://192.168.1.1:8899/
```

## Telegram-Ready Commands

Send this block to a user. Commands must be entered one by one in `http://192.168.1.1/a`.

```text
1. Откройте:
http://192.168.1.1/a

2. Введите:
opkg disk OPKG:/ https://bin.entware.net/aarch64-k3.10/installer/aarch64-installer.tar.gz

3. После завершения введите:
opkg initrc /opt/etc/init.d/rc.unslung

4. Потом:
system configuration save

5. Потом:
system reboot

6. Подождите 2-5 минут. Снова откройте:
http://192.168.1.1/a

7. Введите:
exec sh -c "/opt/bin/wget -O - https://raw.githubusercontent.com/opengater/opengater-keenetic-antigoblin-installer/main/install.sh | /opt/bin/sh"

8. После завершения откройте:
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

## How It Works

Keenetic Web CLI has two different worlds:

1. Keenetic commands, for example:

```sh
opkg disk OPKG:/ https://bin.entware.net/aarch64-k3.10/installer/aarch64-installer.tar.gz
opkg initrc /opt/etc/init.d/rc.unslung
system configuration save
system reboot
```

These commands are handled by KeeneticOS itself.

2. Entware shell command:

```sh
exec sh -c "/opt/bin/wget -O - https://raw.githubusercontent.com/opengater/opengater-keenetic-antigoblin-installer/main/install.sh | /opt/bin/sh"
```

This command asks KeeneticOS to start a shell command. The shell command downloads this repository's `install.sh` and runs it with `/opt/bin/sh`.

That is why Entware must be installed first. The wrapper is intentionally separate from the official Entware installer.

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
