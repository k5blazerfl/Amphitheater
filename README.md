# Amphitheater

A personal [Gentoo](https://www.gentoo.org/) overlay (Portage ebuild repository).

## Packages

| Package | Description |
| --- | --- |
| `app-admin/gest` | [GeST](https://github.com/k5blazerfl/GeST) — a YaST-style, full-screen TUI system administration tool for Gentoo (Portage, services, users, network). Released `0.31.5` + live `-9999`. |
| `media-sound/pyrrha` | [Pyrrha](https://github.com/k5blazerfl/Pyrrha) — a Qt (PySide6) Pandora Radio client, a port of Pithos. Live `-9999` ebuild. |

## Enabling the overlay

With [eselect-repository](https://wiki.gentoo.org/wiki/Eselect/Repository) (recommended):

```sh
eselect repository add amphitheater git https://github.com/k5blazerfl/Amphitheater.git
emaint sync -r amphitheater
```

Or manually, create `/etc/portage/repos.conf/amphitheater.conf`:

```ini
[amphitheater]
location = /var/db/repos/amphitheater
sync-type = git
sync-uri = https://github.com/k5blazerfl/Amphitheater.git
auto-sync = yes
```

then `emerge --sync amphitheater`.

## Installing Pyrrha

```sh
emerge -av media-sound/pyrrha
```

`media-sound/pyrrha` is a live (`-9999`) ebuild that builds from Pyrrha's `main`
branch, so it has empty `KEYWORDS`; accept it with:

```sh
echo "media-sound/pyrrha **" >> /etc/portage/package.accept_keywords/pyrrha
```

USE flags: `lastfm` (scrobbling, on by default) and `journald` (systemd journal
logging).

## Installing GeST

```sh
echo "app-admin/gest ~amd64" >> /etc/portage/package.accept_keywords/gest
emerge -av app-admin/gest
rc-service dbus reload   # so D-Bus sees the new policy/activation
```

`app-admin/gest-0.31.5` is a released version (`~amd64`); `gest-9999` tracks
GeST's `main`. The privileged backend bus-activates on first use (polkit-gated).

GeST's runtime dependencies (`dev-python/urwid`, `dev-python/dbus-next`,
`dev-python/pygobject`, `sys-apps/portage`) are all in `::gentoo`, so it resolves
without any extra overlays.

## License

Ebuilds are distributed under the GPL-2 (Gentoo convention); the packaged
software carries its own license.
