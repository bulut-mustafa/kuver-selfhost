# Troubleshooting

## The Kuver app
**"Can't reach the server" when choosing your own server**
Open the same address in a browser on the venue computer. If it doesn't load, the problem is the
network: the port (`:4000`), a firewall on the server, or the server not running
(`docker compose ps` in the `kuver` folder).

**The browser page for signing in doesn't open**
Click **Open the browser page again** in the app. If your default browser is unusual, copy the
address it opens into Chrome, Edge, Safari or Firefox.

**No cameras found**
- The computer must be on the same network as the recorder, not a guest Wi-Fi.
- Type the recorder's address by hand. On most recorders it's under Network settings; your router's
  device list shows it too.
- Some recorders have RTSP or ONVIF switched off: turn it on in the recorder's network settings.

**"Wrong user name or password"** for the recorder
Use the recorder's own login (the one its phone app uses), not your Kuver account. After several
wrong tries many recorders lock the account for a few minutes.

**A camera shows black or "no camera"**
That channel has no camera connected, or the camera is off. Check the recorder's own screen or app.

**Tables are drawn in the wrong place**
In the console, open the camera and click **Edit zones**. Remove wrong shapes and draw new ones by
clicking on the picture, then click **Done**. Kuver keeps your drawing from then on.

**The computer went to sleep**
Set it to never sleep while plugged in (Windows: Settings → System → Power; Mac: System Settings →
Energy / Lock Screen). Kuver can't watch while the computer sleeps.

## The console
**The console says the venue computer is offline**
The Kuver app isn't running or the computer is off or offline. Open the app on the venue computer.
Kuver catches up when it reconnects.

**No alerts on my phone**
- Alerts need HTTPS. Kuver Cloud always has it; a self-hosted server needs a domain or a tunnel.
- Turn them on per device in **Settings → Notifications** and allow notifications when asked.
- iPhone: add Kuver to the Home Screen first and open it from there.
- Check the phone isn't in Focus / Do Not Disturb.

**I forgot my password**
On Kuver Cloud, write to hello@kuver.app. On a self-hosted server, another owner can remove your
account and invite you again.

## A self-hosted server
**See what the server is doing:** `docker compose logs server --tail 100`

**Start over completely** (deletes all data):
```sh
docker compose down -v
```

**Moving the server to another machine:** back up on the old one, install on the new one, restore
(see the README), then change the server address in the Kuver app at the venue.

Still stuck? Open an [issue](https://github.com/bulut-mustafa/kuver-selfhost/issues). Include what
you did, what you expected, and the last lines of the server log, with passwords removed.
