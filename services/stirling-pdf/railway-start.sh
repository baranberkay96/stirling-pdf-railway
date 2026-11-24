#!/bin/bash
# Railway start wrapper for Stirling PDF: validates the deploy-form variables,
# then runs the image's /scripts/init.sh. Never exits because of a value (8.29).
set -u

log() { echo "railway-start: $*"; }
random_secret() { tr -dc 'A-Za-z0-9' </dev/urandom 2>/dev/null | head -c 40; }

# --- Port: Spring Boot reads SERVER_PORT, Railway's healthcheck uses PORT. ---
if ! [[ "${PORT:-}" =~ ^[0-9]{1,5}$ ]] || [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then
  [ -n "${PORT:-}" ] && log "WARNING: PORT='${PORT}' is not a valid port, using 8080"
  export PORT=8080
fi
export SERVER_PORT="$PORT"

# --- Login: always on while the service has a public domain. ---
login="${SECURITY_ENABLELOGIN:-true}"
case "${login,,}" in
  true|1|yes|on) login=true ;;
  false|0|no|off) login=false ;;
  *) log "WARNING: SECURITY_ENABLELOGIN='${login}' is not true/false, using true"; login=true ;;
esac
if [ "$login" = false ] && [ -n "${RAILWAY_PUBLIC_DOMAIN:-}" ]; then
  log "WARNING: SECURITY_ENABLELOGIN=false is ignored: this service has a public domain (${RAILWAY_PUBLIC_DOMAIN})."
  log "         Remove the public domain first if Stirling PDF should run without a login on the private network."
  login=true
fi
export SECURITY_ENABLELOGIN="$login"
# DOCKER_ENABLE_SECURITY is the pre-1.0 name of the same switch; keep them equal.
export DOCKER_ENABLE_SECURITY="$login"

# --- First admin (created only on the first boot, when the user table is empty). ---
user="${SECURITY_INITIALLOGIN_USERNAME:-}"
if ! [[ "$user" =~ ^[A-Za-z0-9._@-]{3,50}$ ]]; then
  log "WARNING: SECURITY_INITIALLOGIN_USERNAME is empty or invalid (3-50 letters, digits, . _ @ -); using 'admin'"
  user=admin
fi
pass="${SECURITY_INITIALLOGIN_PASSWORD:-}"
if [ "${#pass}" -lt 12 ] || [ "${#pass}" -gt 128 ] || [[ "$pass" =~ [[:space:][:cntrl:]] ]]; then
  log "WARNING: SECURITY_INITIALLOGIN_PASSWORD is empty, shorter than 12 or longer than 128 characters, or contains spaces."
  log "         On a first boot the admin '${user}' gets a random password nobody knows (no default admin/stirling login)."
  log "         Fix: set a password of 12-128 characters, delete the volume's /configs/stirling-pdf-DB* files"
  log "         (only on a fresh install) and redeploy. Existing installs keep their stored passwords."
  pass="$(random_secret)"
fi
export SECURITY_INITIALLOGIN_USERNAME="$user" SECURITY_INITIALLOGIN_PASSWORD="$pass"
unset pass

# --- API key for scripts and automations (X-API-KEY header). Empty or short = none. ---
key="${SECURITY_CUSTOMGLOBALAPIKEY:-}"
if [ -n "$key" ] && { [ "${#key}" -lt 24 ] || [[ "$key" =~ [[:space:]] ]]; }; then
  log "WARNING: SECURITY_CUSTOMGLOBALAPIKEY is shorter than 24 characters or has spaces; the global API key is disabled."
  unset SECURITY_CUSTOMGLOBALAPIKEY
fi
unset key

# --- Upload limit in MB. ---
if [ -n "${SYSTEM_MAXFILESIZE:-}" ] && ! [[ "$SYSTEM_MAXFILESIZE" =~ ^[0-9]{1,6}$ ]]; then
  log "WARNING: SYSTEM_MAXFILESIZE='${SYSTEM_MAXFILESIZE}' is not a number of MB, using 2000"
  export SYSTEM_MAXFILESIZE=2000
fi

log "Stirling PDF on port ${PORT}, login ${login} (first admin '${user}')"
exec /scripts/init.sh "$@"
