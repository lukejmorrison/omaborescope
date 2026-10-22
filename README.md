# OmaBorescope

![OmaBorescope](assets/icon.png)

Watch a General Tools iBorescope4 (DCiS4 / iSNAKESCOPE) from an Omarchy PC.

The scope is its own Wi-Fi network. OmaBorescope joins `iSNAKESCOPE`, leaves your normal default route alone, and opens the live picture. Photo and Record save into `Pictures/OmaBorescope` and `Videos/OmaBorescope`.

Click the scope's thumbwheel and wait until the green light flashes slowly before you press Watch.

## Install

```bash
omarchy plugin add https://github.com/lukejmorrison/omaborescope.git --enable --yes
```

A **Scope** button appears on the right side of the bar. Click it for Watch, Photo, Record, Stop, and Disconnect. Esc closes that panel and leaves the live picture up. Stop closes the picture and the recording.

From a terminal:

```bash
~/.config/omarchy/plugins/lukejmorrison.omaborescope/bin/omaborescope watch
```

The factory Wi-Fi password from the quick start is used automatically. If you changed it on the scope, set `OMABORESCOPE_WIFI_PSK` before launching.

## Android app

The phone app is [wizwam-borescope.apk](https://github.com/lukejmorrison/omaborescope/releases/latest/download/wizwam-borescope.apk). It runs on Android 8.1 and newer. The **Android** button in the panel opens that download.

Install the APK from the file manager after it downloads. The app joins `iSNAKESCOPE` when you open it and can take photos and clips.
