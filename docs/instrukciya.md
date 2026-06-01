# Короткая инструкция для пользователя

Все команды вводятся по одной в Web CLI Keenetic:

```text
http://192.168.1.1/a
```

Флешка должна называться ровно:

```text
OPKG
```

## Команды

Установить Entware:

```sh
opkg disk OPKG:/ https://bin.entware.net/aarch64-k3.10/installer/aarch64-installer.tar.gz
```

Указать сценарий запуска Entware:

```sh
opkg initrc /opt/etc/init.d/rc.unslung
```

Сохранить настройки:

```sh
system configuration save
```

Перезагрузить роутер:

```sh
system reboot
```

Подождать 2-5 минут и снова открыть:

```text
http://192.168.1.1/a
```

Установить AntiGoblin:

```sh
exec sh -c "/opt/bin/wget -O - https://raw.githubusercontent.com/mrkvka/keenetic-web-cli-ustanovka-antigoblin/main/install.sh | /opt/bin/sh"
```

После завершения открыть панель:

```text
http://192.168.1.1:8899/
```

SSH не нужен.
