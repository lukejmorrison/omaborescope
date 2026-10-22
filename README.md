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

Watch joins the scope on a separate NetworkManager connection named `omaborescope`. That connection does not become the default route. Disconnect drops it and brings back the Wi-Fi you were using.

## Remove

```bash
omarchy plugin remove lukejmorrison.omaborescope --yes
```

Photos and clips already saved in `Pictures/OmaBorescope` and `Videos/OmaBorescope` stay where they are. To drop the scope Wi-Fi profile as well:

```bash
nmcli connection delete omaborescope
```

## Dependencies

Omarchy already provides these:

- NetworkManager (`nmcli`), to join the scope when you press Watch
- `curl`, to talk to the camera
- `mpv`, for the live picture
- `ffmpeg`, to record a clip
- `xdg-open`, for the Android download button
- `notify-send`, for the photo notification

## License

[MIT](LICENSE).

From a terminal:

```bash
~/.config/omarchy/plugins/lukejmorrison.omaborescope/bin/omaborescope watch
```

The factory Wi-Fi password from the quick start is used automatically. If you changed it on the scope, set `OMABORESCOPE_WIFI_PSK` before launching.

## Android app

The phone app is [wizwam-borescope.apk](https://github.com/lukejmorrison/omaborescope/releases/latest/download/wizwam-borescope.apk). It runs on Android 8.1 and newer. The **Android** button in the panel opens that download.

Install the APK from the file manager after it downloads. The app joins `iSNAKESCOPE` when you open it and can take photos and clips.
