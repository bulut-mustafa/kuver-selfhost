# The Kuver app at the venue

The Kuver app runs on one always-on computer at the venue. It finds the cameras, watches the video
right there, and sends your Kuver account the table timings and alerts. It's the same app for Kuver
Cloud and for a self-hosted server.

## Before you start
- **The computer:** Windows 10/11 (64-bit) or macOS 12 or newer. It stays on during opening hours
  (ideally always), on the same network as the cameras: same Wi-Fi or router, wired if possible.
  8 GB of memory recommended.
- **The cameras:** a video recorder (NVR/DVR) or IP cameras with RTSP or ONVIF (most brands:
  Hikvision, Dahua, Reolink, Uniview, Axis, and the many recorders built on them). Have the recorder's
  user name and password ready, the ones its own phone app uses.
- **Your Kuver account:** create it on [Kuver Cloud](https://kuver.onrender.com) or on your own server.
  You can also create it during setup.

## 1. Install
- **Windows:** download [Kuver-windows-setup.exe](https://github.com/bulut-mustafa/kuver-selfhost/releases/latest/download/Kuver-windows-setup.exe) and open it.
  Windows may show **"Windows protected your PC"** the first time: click **More info**, then
  **Run anyway**. (This appears for new apps until Microsoft has seen enough installs.)
- **Mac:** download [Kuver-mac.dmg](https://github.com/bulut-mustafa/kuver-selfhost/releases/latest/download/Kuver-mac.dmg),
  open it and drag **Kuver** into **Applications**, then open it from there.

## 2. Sign in
The welcome screen says **Signing in to Kuver Cloud**.
- **Using Kuver Cloud:** click **Sign in with your browser**.
- **Using your own server:** first click **Use my own Kuver server**, type its address (for example
  `192.168.1.20:4000` or `kuver.example.com`), and click **Use it**. Then click **Sign in with your
  browser**.

Your browser opens Kuver. Sign in (or create your account), choose the location (or add one), and
click **Connect**. Go back to the app: it has moved on by itself.

## 3. Find the cameras
The app searches the network for about 20 seconds and lists the recorders and cameras it finds.
Click yours and choose **Use this**.

If nothing shows up, type the recorder's address under **Know the address?**. You can find it in the
recorder's menu, its phone app, or your router's list of devices.

## 4. Log in to the recorder
Enter the recorder's user name and password and click **Show cameras**. You see a picture from every
channel. Tick the ones to use (start with the dining room), rename them if you like ("Terrace",
"Window side"), and click **Add**.

The recorder login is kept only on this computer. It's never sent to Kuver.

## 5. Check the tables
For each camera Kuver draws the tables it found.
- **Wrong one:** click it, then **Remove selected**.
- **Missing one:** click **+ Add a table** and drag a box around it.

You can fine-tune the shapes later from the console.

## 6. Done
Leave **Start Kuver when this computer starts** ticked, then click **Open the console**.

Closing the window keeps Kuver running in the background: on Windows it's in the tray by the clock,
on a Mac in the menu bar. Quit it from there only if you want it to stop watching.

## Using Kuver every day
- **The console** (in the app, or in any browser at your Kuver address) shows each table live:
  seated, waiting, served, needs clearing, with the time.
- **Alerts:** in **Settings → Notifications**, turn on alerts for each phone or laptop that should get
  them. On iPhone, first open Kuver in Safari, tap **Share → Add to Home Screen**, open it from the
  Home Screen, then turn alerts on.
- **Targets:** in **Settings**, set how long is too long for a first greeting, food, or a table reset.
- **Reports and the daily summary** show the shift against those targets.

## Moving to another computer
Install the app on the new computer and sign in to the same location. Kuver asks whether this
computer should take over. The old one stops and its window says so.

## Removing it
- **Windows:** Settings → Apps → Kuver → Uninstall.
- **Mac:** quit Kuver from the menu bar and move it from Applications to the Bin.

To disconnect a venue computer from anywhere, open **Setup** in the console on the website and remove it there.
