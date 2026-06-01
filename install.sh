#!/opt/bin/sh

set -u

LOG_TAG="opengater-antigoblin"
UPSTREAM_URL="${UPSTREAM_URL:-https://raw.githubusercontent.com/MaksimSamarin/AntiGoblin/main/install.sh}"
FLAG_DIR="/opt/var/lib/opengater-antigoblin"
FLAG_FILE="$FLAG_DIR/installed"
UPSTREAM_FILE="/opt/tmp/opengater-antigoblin-install.sh"
PATH=/opt/sbin:/opt/bin:/opt/usr/sbin:/opt/usr/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

log() {
  echo "[$LOG_TAG] $*"
  logger -t "$LOG_TAG" "$*" 2>/dev/null || true
}

die() {
  log "ERROR: $*"
  exit 1
}

require_entware() {
  [ -x /opt/bin/opkg ] || die "Entware is not installed or /opt is not mounted"
  [ -x /opt/bin/wget ] || die "wget is not available in Entware"
  [ -x /opt/bin/sh ] || die "/opt/bin/sh is not available"
}

install_prerequisites() {
  log "Updating Entware package lists"
  /opt/bin/opkg update >/dev/null 2>&1 || die "opkg update failed"

  for pkg in ca-bundle wget tar gzip; do
    if ! /opt/bin/opkg list-installed | /opt/bin/grep -q "^${pkg} "; then
      log "Installing package: $pkg"
      /opt/bin/opkg install "$pkg" >/dev/null 2>&1 || die "failed to install $pkg"
    fi
  done
}

download_upstream() {
  log "Downloading AntiGoblin installer"
  /opt/bin/wget -O "$UPSTREAM_FILE" "$UPSTREAM_URL" >/dev/null 2>&1 || die "failed to download AntiGoblin installer"
  /opt/bin/chmod 700 "$UPSTREAM_FILE" 2>/dev/null || true
}

run_upstream() {
  log "Starting AntiGoblin installer"
  /opt/bin/sh "$UPSTREAM_FILE"
}

main() {
  if [ -f "$FLAG_FILE" ]; then
    log "AntiGoblin was already installed by this wrapper; running upstream installer again for repair/update"
  fi

  require_entware
  install_prerequisites
  download_upstream
  run_upstream

  /opt/bin/mkdir -p "$FLAG_DIR" 2>/dev/null || true
  date >"$FLAG_FILE" 2>/dev/null || true
  log "Done. Open AntiGoblin panel: http://192.168.1.1:8899/"
}

main "$@"
