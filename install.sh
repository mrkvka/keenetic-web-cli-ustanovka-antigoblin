#!/opt/bin/sh

set -u

LOG_TAG="antigoblin-web-cli"
UPSTREAM_URL="${UPSTREAM_URL:-https://raw.githubusercontent.com/MaksimSamarin/AntiGoblin/main/install.sh}"
FLAG_DIR="/opt/var/lib/antigoblin-web-cli"
FLAG_FILE="$FLAG_DIR/installed"
UPSTREAM_FILE="/opt/tmp/antigoblin-web-cli-install.sh"
PATH=/opt/sbin:/opt/bin:/opt/usr/sbin:/opt/usr/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

log() {
  echo "[$LOG_TAG] $*"
  logger -t "$LOG_TAG" "$*" 2>/dev/null || true
}

die() {
  log "ОШИБКА: $*"
  exit 1
}

require_entware() {
  [ -x /opt/bin/opkg ] || die "Entware не установлен или /opt не смонтирован"
  [ -x /opt/bin/wget ] || die "wget недоступен в Entware"
  [ -x /opt/bin/sh ] || die "/opt/bin/sh недоступен"
}

install_prerequisites() {
  log "Обновляем список пакетов Entware"
  /opt/bin/opkg update >/dev/null 2>&1 || die "opkg update завершился с ошибкой"

  for pkg in ca-bundle wget tar gzip; do
    if ! /opt/bin/opkg list-installed | /opt/bin/grep -q "^${pkg} "; then
      log "Устанавливаем пакет: $pkg"
      /opt/bin/opkg install "$pkg" >/dev/null 2>&1 || die "не удалось установить пакет $pkg"
    fi
  done
}

download_upstream() {
  log "Скачиваем установщик AntiGoblin"
  /opt/bin/wget -O "$UPSTREAM_FILE" "$UPSTREAM_URL" >/dev/null 2>&1 || die "не удалось скачать установщик AntiGoblin"
  /opt/bin/chmod 700 "$UPSTREAM_FILE" 2>/dev/null || true
}

run_upstream() {
  log "Запускаем установщик AntiGoblin"
  /opt/bin/sh "$UPSTREAM_FILE"
}

main() {
  if [ -f "$FLAG_FILE" ]; then
    log "AntiGoblin уже устанавливался этим скриптом; запускаем установщик повторно для восстановления или обновления"
  fi

  require_entware
  install_prerequisites
  download_upstream
  run_upstream

  /opt/bin/mkdir -p "$FLAG_DIR" 2>/dev/null || true
  date >"$FLAG_FILE" 2>/dev/null || true
  log "Готово. Откройте панель AntiGoblin: http://192.168.1.1:8899/"
}

main "$@"
