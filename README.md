# Установка AntiGoblin на Keenetic через Web CLI

Этот репозиторий содержит маленький установочный скрипт для роутеров Keenetic.

Задача: поставить AntiGoblin без SSH, PuTTY и терминала. Пользователь вводит команды только во встроенной веб-командной строке Keenetic:

```text
http://192.168.1.1/a
```

## Что делает эта инструкция

Установка состоит из двух частей:

1. Сначала ставится официальный Entware.
2. Потом через Web CLI запускается установщик AntiGoblin.

Entware ставится штатной командой Keenetic:

```sh
opkg disk OPKG:/ https://bin.entware.net/aarch64-k3.10/installer/aarch64-installer.tar.gz
```

AntiGoblin ставится отдельной командой через Web CLI:

```sh
exec sh -c "/opt/bin/wget -O - https://raw.githubusercontent.com/mrkvka/keenetic-web-cli-ustanovka-antigoblin/main/install.sh | /opt/bin/sh"
```

## Почему нельзя поставить всё одной командой

Скрипт `install.sh` из этого репозитория запускается внутри Entware.

До установки Entware на роутере ещё нет нужных файлов:

```text
/opt/bin/sh
/opt/bin/wget
/opt/bin/opkg
```

Поэтому порядок всегда такой:

1. Сначала официальный Entware через `opkg disk`.
2. Потом AntiGoblin через `exec sh -c`.

## Подготовка

Флешка должна быть отформатирована в `EXT4` и называться ровно:

```text
OPKG
```

Не `OPGK`, не `opkg`, не `USB`. Именно `OPKG`.

В Keenetic должны быть установлены компоненты:

- поддержка открытых пакетов / OPKG;
- файловая система Ext или Ext4;
- модули ядра Netfilter;
- Xtables-addons для Netfilter;
- Traffic Control, если компонент доступен.

SSH для основного сценария не нужен.

## Команды для пользователя

Откройте:

```text
http://192.168.1.1/a
```

Введите первую команду:

```sh
opkg disk OPKG:/ https://bin.entware.net/aarch64-k3.10/installer/aarch64-installer.tar.gz
```

После завершения введите:

```sh
opkg initrc /opt/etc/init.d/rc.unslung
```

Сохраните конфигурацию:

```sh
system configuration save
```

Перезагрузите роутер:

```sh
system reboot
```

Подождите 2-5 минут. После перезагрузки снова откройте:

```text
http://192.168.1.1/a
```

Введите команду установки AntiGoblin:

```sh
exec sh -c "/opt/bin/wget -O - https://raw.githubusercontent.com/mrkvka/keenetic-web-cli-ustanovka-antigoblin/main/install.sh | /opt/bin/sh"
```

После завершения установки откройте панель AntiGoblin:

```text
http://192.168.1.1:8899/
```

## Что делает `install.sh`

Скрипт запускается уже после установки Entware и выполняет следующие действия:

- проверяет, что `/opt/bin/opkg`, `/opt/bin/wget` и `/opt/bin/sh` доступны;
- выполняет `opkg update`;
- ставит базовые пакеты для скачивания и распаковки, если их нет;
- скачивает оригинальный установщик AntiGoblin;
- запускает оригинальный установщик AntiGoblin через `/opt/bin/sh`;
- пишет сообщения в вывод Web CLI и в системный журнал Keenetic с тегом `antigoblin-web-cli`.

## Как это работает технически

Команды ниже выполняются самой прошивкой Keenetic:

```sh
opkg disk OPKG:/ https://bin.entware.net/aarch64-k3.10/installer/aarch64-installer.tar.gz
opkg initrc /opt/etc/init.d/rc.unslung
system configuration save
system reboot
```

После установки Entware можно выполнить shell-команду через Web CLI:

```sh
exec sh -c "/opt/bin/wget -O - https://raw.githubusercontent.com/mrkvka/keenetic-web-cli-ustanovka-antigoblin/main/install.sh | /opt/bin/sh"
```

Эта команда скачивает `install.sh` из этого репозитория и запускает его через `/opt/bin/sh`.

## Проверка перед публикацией

Проверить синтаксис скрипта:

```sh
sh -n install.sh
```

Проверить, что ссылка открывается:

```sh
curl -fsSL https://raw.githubusercontent.com/mrkvka/keenetic-web-cli-ustanovka-antigoblin/main/install.sh | head
```

## Ограничение

Если в конкретной версии KeeneticOS команда `exec sh -c` не сработает, запасной вариант всё ещё SSH. Основной сценарий этого репозитория рассчитан именно на установку через Web CLI Keenetic.
