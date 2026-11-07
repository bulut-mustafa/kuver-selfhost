#!/bin/sh
# Kuver self-host installer: sets up Kuver in ~/kuver (or $KUVER_DIR) and starts it.
#   curl -fsSL https://raw.githubusercontent.com/bulut-mustafa/kuver-selfhost/main/install.sh | sh
# With your own domain (automatic HTTPS):
#   curl -fsSL https://raw.githubusercontent.com/bulut-mustafa/kuver-selfhost/main/install.sh | KUVER_DOMAIN=kuver.example.com sh
# Running it again updates Kuver and keeps your settings and data.
set -eu

BASE="${KUVER_BASE:-https://raw.githubusercontent.com/bulut-mustafa/kuver-selfhost/main}"
DIR="${KUVER_DIR:-$HOME/kuver}"
say() { printf '\033[1m%s\033[0m\n' "$*"; }
fail() { printf '\033[31m%s\033[0m\n' "$*" >&2; exit 1; }

command -v docker >/dev/null 2>&1 || fail "Docker is not installed. Get it from https://docs.docker.com/get-docker/ and run this again."
docker info >/dev/null 2>&1 || fail "Docker is installed but not running (or needs sudo). Start Docker and run this again."
docker compose version >/dev/null 2>&1 || fail "Docker Compose v2 is missing. Update Docker and run this again."

random() { (openssl rand -hex 24 2>/dev/null) || (LC_ALL=C tr -dc 'a-f0-9' < /dev/urandom | head -c 48); }

say "Setting up Kuver in $DIR"
mkdir -p "$DIR" && cd "$DIR"
curl -fsSL "$BASE/docker-compose.yml" -o docker-compose.yml

if [ ! -f .env ]; then
  curl -fsSL "$BASE/.env.example" -o .env
  sed -i.bak "s/^POSTGRES_PASSWORD=.*/POSTGRES_PASSWORD=$(random)/" .env && rm -f .env.bak
  chmod 600 .env
  say "Created .env with a new database password (keep a copy somewhere safe)."
fi

if [ -n "${KUVER_DOMAIN:-}" ]; then
  grep -v -E '^#? ?(KUVER_DOMAIN|COMPOSE_PROFILES|SECURE_COOKIES|TRUST_PROXY)=' .env > .env.new
  printf 'KUVER_DOMAIN=%s\nCOMPOSE_PROFILES=https\nSECURE_COOKIES=1\nTRUST_PROXY=1\n' "$KUVER_DOMAIN" >> .env.new
  mv .env.new .env && chmod 600 .env
fi

say "Downloading and starting Kuver (the first time takes a minute)"
docker compose pull -q || say "Couldn't download the newest version; starting the one already on this machine."
docker compose up -d || fail "Kuver could not start. See: cd $DIR && docker compose logs"

PORT=$(grep -E '^KUVER_PORT=' .env | cut -d= -f2); PORT=${PORT:-4000}
i=0
until curl -fsS "http://127.0.0.1:$PORT/healthz" >/dev/null 2>&1; do
  i=$((i + 1)); [ $i -gt 90 ] && fail "Kuver did not start. See: cd $DIR && docker compose logs server"
  sleep 1
done

IP=$( (hostname -I 2>/dev/null | awk '{print $1}') || true)
[ -n "$IP" ] || IP=$( (ipconfig getifaddr en0 2>/dev/null) || true)
DOMAIN=$(grep -E '^KUVER_DOMAIN=' .env | cut -d= -f2 || true)
echo
say "Kuver is running."
echo "  On this machine:      http://localhost:$PORT"
[ -n "$IP" ] && echo "  On your network:      http://$IP:$PORT"
[ -n "$DOMAIN" ] && echo "  With your domain:     https://$DOMAIN   (once its DNS points here)"
echo
echo "Next: open the address, create your account (the first one is the owner), then install"
echo "the Kuver app on the venue computer and choose \"My own Kuver server\"."
echo "Guide: https://github.com/bulut-mustafa/kuver-selfhost#readme"
