# Kuver: self-host it, free

Kuver shows a restaurant, café or hotel how service is going at every table, using the cameras it
already has: who was greeted, who is waiting for food, which tables need resetting. All measured
against your own targets, and you get alerts on your phone.

You can use Kuver two ways:

| | **Kuver Cloud** | **Self-hosted** (this repository) |
|---|---|---|
| Who runs the server | We do | You do, on your own machine |
| Price | 14 days free, then per location | Free for one location ([Community](#editions)) |
| Setup | Create an account, install the app | One command, then the same app |
| Updates and backups | Automatic | You run them (one command each) |

If you'd rather not run a server, use **[Kuver Cloud](https://kuver.onrender.com)** instead. Everything
below is about self-hosting.

**Contents:**
1. [How it fits together](#how-it-fits-together)
2. [What you need](#what-you-need)
3. [Install](#install)
4. [First steps](#first-steps)
5. [Use it outside the venue](#use-it-outside-the-venue)
6. [Invite your team](#invite-your-team)
7. [Update](#update)
8. [Back up and restore](#back-up-and-restore)
9. [Settings](#settings)
10. [Troubleshooting](#troubleshooting)
11. [Privacy](#privacy)
12. [Editions](#editions)
13. [Licence](#licence)

More guides:
- [The Kuver app at the venue](docs/venue-app.md)
- [Troubleshooting in detail](docs/troubleshooting.md)

---

## How it fits together

```
 cameras / recorder ──►  Kuver app on a venue computer  ──►  your Kuver server  ◄── you, on phone or laptop
   (already there)        (watches the video, locally)        (this repository)       (console, reports, alerts)
```

- **The Kuver app** runs on an always-on computer at the venue. It finds the cameras, processes the
  video right there, and sends the server only table timings and alerts. Video is never uploaded.
- **The Kuver server** keeps the accounts, the timings and the reports, sends the alerts, and serves
  the console you open in a browser. That is what you install here.

The server and the app can be on the same computer.

## What you need

**For the server:**
- A machine with **Docker**: a small cloud server (VPS), a NAS, a home server, or the venue
  computer itself. Linux, Mac or Windows with [Docker Desktop](https://docs.docker.com/get-docker/).
- At least 1 GB of memory and 2 GB of free disk.

**At the venue:**
- An always-on computer with Windows 10/11 (64-bit) or macOS 12 or newer, on the same network as the
  cameras. We recommend 8 GB of memory.
- IP cameras or a video recorder (NVR/DVR) that offers RTSP or ONVIF. Most do. You need its user name
  and password, the same ones its own app uses.

## Install

On the server machine, run:

```sh
curl -fsSL https://raw.githubusercontent.com/bulut-mustafa/kuver-selfhost/main/install.sh | sh
```

It checks Docker, creates the folder `~/kuver` with a fresh database password, starts Kuver, and
prints the addresses to open, for example `http://192.168.1.20:4000`.

<details>
<summary><b>Install by hand</b> (Windows PowerShell, or if you prefer to see each step)</summary>

1. Make a folder and download two files into it:
   ```sh
   mkdir kuver && cd kuver
   curl -fsSLO https://raw.githubusercontent.com/bulut-mustafa/kuver-selfhost/main/docker-compose.yml
   curl -fsSL https://raw.githubusercontent.com/bulut-mustafa/kuver-selfhost/main/.env.example -o .env
   ```
2. Open `.env` and replace `change-me` after `POSTGRES_PASSWORD=` with a long random password.
3. Start it:
   ```sh
   docker compose up -d
   ```
4. Open `http://localhost:4000`.

</details>

## First steps

1. **Create your account.** Open the address and choose **Create account**. The first account on a
   server is the owner. After that, sign-up closes and people join only with an invite
   ([Invite your team](#invite-your-team)).
2. **Add your location.** Give it a name, pick its time zone and type. You land on an empty console.
3. **Install the Kuver app on the venue computer.** Download it for
   [Windows](https://github.com/bulut-mustafa/kuver-selfhost/releases/latest/download/Kuver-windows-setup.exe) or
   [Mac](https://github.com/bulut-mustafa/kuver-selfhost/releases/latest/download/Kuver-mac.dmg)
   and open it.
4. **Point it at your server.** On the welcome screen click **Use my own Kuver server**, type your
   server's address (for example `192.168.1.20:4000`), and click **Use it**. The app checks that the
   server answers.
5. **Sign in.** Click **Sign in with your browser**, sign in, choose your location and click
   **Connect**. The app continues by itself.
6. **Add the cameras.** The app searches the network for recorders and cameras (about 20 seconds).
   Pick yours, enter its user name and password, tick the cameras to use, and click **Add**.
7. **Check the tables.** Kuver draws the tables it sees on each camera. Remove wrong ones and drag a
   box around any it missed.
8. **Done.** Leave **Start Kuver when this computer starts** ticked. Open the console from any
   browser, and turn on alerts in **Settings → Notifications** on your phone.

The app guide has the details and pictures: [docs/venue-app.md](docs/venue-app.md).

## Use it outside the venue

The steps above work inside your network. To open the console from anywhere (and get alerts on
your phone away from the venue), give the server a web address with HTTPS. Pick one:

**A. Your own domain, with the built-in HTTPS (simplest if you have a domain):**
1. At your domain provider, point a name (for example `kuver.example.com`) at the server's public IP
   address. Make sure ports 80 and 443 reach the server: on a home network, forward them on the
   router.
2. Run the installer again with the name:
   ```sh
   curl -fsSL https://raw.githubusercontent.com/bulut-mustafa/kuver-selfhost/main/install.sh | KUVER_DOMAIN=kuver.example.com sh
   ```
   Kuver gets a free certificate automatically. Open `https://kuver.example.com`.
3. In the Kuver app at the venue, use that address as your server.

**B. No domain, no open ports:** use a tunnel such as
[Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/) or
[Tailscale](https://tailscale.com) (private to your devices). Point it at `http://localhost:4000`,
then set `SECURE_COOKIES=1` and `TRUST_PROXY=1` in `.env` and run `docker compose up -d`.

**C. Your own reverse proxy** (nginx, Traefik, Caddy): forward everything, including WebSockets, to
port 4000. Then set `SECURE_COOKIES=1` and `TRUST_PROXY=1` as in B.

## Invite your team

In the console open **Team → Invite**, enter their email and role, and send them the link. They open
it, create their account and see the location. Roles in Community:
- **Owner:** everything, including the team and settings.
- **Venue manager:** the console, reports and alerts.

To let anyone sign up without an invite, set `KUVER_OPEN_SIGNUP=1`.

## Update

Run the installer again. It keeps your settings and data:

```sh
curl -fsSL https://raw.githubusercontent.com/bulut-mustafa/kuver-selfhost/main/install.sh | sh
```

Or by hand, in the `kuver` folder: `docker compose pull && docker compose up -d`.

The Kuver app at the venue updates itself.

## Back up and restore

Everything is in the database: accounts, locations, tables, timings, reports. There's no video to back up.

**Back up** (in the `kuver` folder; put it in a daily cron job):
```sh
docker compose exec -T db pg_dump --clean --if-exists -U kuver kuver | gzip > kuver-$(date +%F).sql.gz
```

**Restore** onto a fresh install (same steps on a new machine, then):
```sh
docker compose stop server
gunzip -c kuver-2026-11-07.sql.gz | docker compose exec -T db psql -U kuver -d kuver
docker compose start server
```

Also keep a copy of `.env`.

## Settings

All settings are in `.env` in the `kuver` folder. After a change run `docker compose up -d`.

| Setting | Default | What it does |
|---|---|---|
| `POSTGRES_PASSWORD` | set by the installer | The database password |
| `KUVER_PORT` | `4000` | The port on this machine |
| `KUVER_DOMAIN` | empty | Your domain for the built-in HTTPS (with `COMPOSE_PROFILES=https`) |
| `SECURE_COOKIES`, `TRUST_PROXY` | `0` | Set both to `1` when Kuver is behind HTTPS |
| `KUVER_OPEN_SIGNUP` | `0` | `1`: anyone may create an account |
| `DIGEST_HOUR` | `22` | Local hour of the end-of-day summary, or `off` |
| `KUVER_LICENSE_KEY` | empty | Enterprise licence key ([Editions](#editions)) |
| `KUVER_TELEMETRY` | `on` | Anonymous weekly statistics ([Privacy](#privacy)); `off` to stop them |
| `KUVER_VERSION` | `latest` | Pin a version, for example `1.0.0` |

## Troubleshooting

| Problem | Fix |
|---|---|
| The installer says Docker isn't running | Start Docker Desktop (or `sudo systemctl start docker`) and run it again. On Linux you may need `sudo sh` at the end of the command. |
| `port is already allocated` | Something else uses port 4000: set `KUVER_PORT=4100` in `.env`, then `docker compose up -d`. |
| The page doesn't open from another device | Use the network address, not `localhost`, and allow port 4000 in the server's firewall. |
| The app says it can't reach the server | Check the address works in a browser on the venue computer, including the port (`:4000`). |
| The app finds no cameras | The venue computer must be on the same network as the recorder. Type the recorder's address by hand (from its app or your router). |
| "Wrong user name or password" for the recorder | Use the recorder's own login, not your Kuver account. Some recorders lock after several wrong tries; wait a few minutes. |
| No alerts on the phone | Notifications need HTTPS ([Use it outside the venue](#use-it-outside-the-venue)). On iPhone, first add the console to the Home Screen. |
| Anything else | `docker compose logs server --tail 100` shows what the server is doing. |

More: [docs/troubleshooting.md](docs/troubleshooting.md). Questions: open an
[issue](https://github.com/bulut-mustafa/kuver-selfhost/issues).

## Privacy

- **Video stays at the venue.** The Kuver app processes it on the venue computer. When someone opens
  a live camera from outside, the pictures go through *your* server to their screen and are not
  stored.
- **Kuver doesn't recognise faces** or identify people. It sees that a table is occupied, served or
  waiting.
- **Your data stays on your server.** We can't see it.
- **Anonymous statistics:** once a week your server tells us a random install id, the Kuver version
  and edition, and the number of locations, cameras and team members. No names, emails, addresses,
  pictures or video. It helps us see how many people run Kuver and which versions to support. Turn it
  off with `KUVER_TELEMETRY=off`.

## Editions

| | Community (free) | Enterprise (licence key) | Kuver Cloud |
|---|---|---|---|
| Cameras, setup, live console, tables, reports, alerts | ✓ | ✓ | ✓ |
| Live view from anywhere | ✓ | ✓ | ✓ |
| Locations | 1 | as licensed | unlimited |
| Roles | owner, venue manager | + area manager | + area manager |
| Audit log | – | ✓ | ✓ |
| Hosting, updates, backups | you | you | us |

For more locations on your own server, ask for an Enterprise licence key at hello@kuver.app. The key
is checked on your server, offline. If it expires, Kuver keeps running as Community and keeps all
your data.

## Licence

Kuver is **fair-code**, under the [Elastic License 2.0](LICENSE). You may use it, change it and run it
for your own business for free. You may not offer it to others as a hosted or managed service, or
remove the licence-key checks. "Kuver" and its logo are trademarks; forks need a different name.
