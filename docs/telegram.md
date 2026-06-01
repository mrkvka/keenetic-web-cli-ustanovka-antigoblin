# Установка AntiGoblin на Keenetic KN-3811 без SSH

Эту инструкцию можно отправить пользователю в Telegram.

## Важно

Флешка должна называться ровно:

```text
OPKG
```

Не `OPGK`, не `opkg`, не `USB`. Именно `OPKG`.

Команды вводятся по одной в:

```text
http://192.168.1.1/a
```

## Команды

1. Откройте:

```text
http://192.168.1.1/a
```

2. Установите Entware:

```sh
opkg disk OPKG:/ https://bin.entware.net/aarch64-k3.10/installer/aarch64-installer.tar.gz
```

3. После завершения введите:

```sh
opkg initrc /opt/etc/init.d/rc.unslung
```

4. Сохраните настройки:

```sh
system configuration save
```

5. Перезагрузите роутер:

```sh
system reboot
```

6. Подождите 2-5 минут. Потом снова откройте:

```text
http://192.168.1.1/a
```

7. Установите AntiGoblin командой Opengater:

```sh
exec sh -c "/opt/bin/wget -O - https://raw.githubusercontent.com/opengater/opengater-keenetic-antigoblin-installer/main/install.sh | /opt/bin/sh"
```

8. После завершения откройте панель:

```text
http://192.168.1.1:8899/
```

## Как это работает

Первая команда ставит официальный Entware на флешку:

```sh
opkg disk OPKG:/ https://bin.entware.net/aarch64-k3.10/installer/aarch64-installer.tar.gz
```

После перезагрузки Entware уже доступен в `/opt`. Поэтому следующая команда может запустить Entware shell:

```sh
exec sh -c "..."
```

Команда Opengater скачивает `install.sh` из GitHub и запускает установку AntiGoblin через `/opt/bin/sh`.

SSH пользователю не нужен.
