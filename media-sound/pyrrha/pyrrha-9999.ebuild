# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 git-r3 xdg

DESCRIPTION="A Qt (PySide6) Pandora Radio client, a port of Pithos"
HOMEPAGE="https://github.com/k5blazerfl/Pyrrha"
EGIT_REPO_URI="https://github.com/k5blazerfl/Pyrrha.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""  # live ebuild
IUSE="+lastfm journald"

# Pyrrha needs PySide6 (QtCore/QtGui/QtWidgets), PyGObject, and GStreamer +
# libsecret with GObject introspection. GStreamer plugins are required for HTTP
# streaming (soup), ReplayGain/limiter/equalizer (good) and MP3/AAC decoding
# (libav). pylast and python-systemd back the optional Last.fm and journald
# plugins.
RDEPEND="
	dev-python/pyside6[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	app-crypt/libsecret[introspection]
	media-libs/gstreamer:1.0[introspection]
	media-libs/gst-plugins-base:1.0[introspection]
	media-plugins/gst-plugins-soup:1.0
	media-plugins/gst-plugins-good:1.0
	media-plugins/gst-plugins-libav:1.0
	lastfm? ( dev-python/pylast[${PYTHON_USEDEP}] )
	journald? ( dev-python/python-systemd[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/glib-utils"

APP_ID="io.github.k5blazerfl.Pyrrha"

python_install_all() {
	distutils-r1_python_install_all

	# GSettings schema (compiled in pkg_postinst).
	insinto /usr/share/glib-2.0/schemas
	doins "pyrrha/data/${APP_ID}.gschema.xml"

	# Desktop entry: point Exec at the installed console script.
	sed -e 's|^Exec=.*|Exec=pyrrha|' \
		"pyrrha/data/${APP_ID}.desktop" > "${T}/${APP_ID}.desktop" || die
	domenu "${T}/${APP_ID}.desktop"

	# Application icon.
	newicon -s 256 pyrrha/icons/pyrrha.png "${APP_ID}.png"
}

pkg_postinst() {
	xdg_pkg_postinst
	glib-compile-schemas "${EROOT}/usr/share/glib-2.0/schemas"
}

pkg_postrm() {
	xdg_pkg_postrm
	glib-compile-schemas "${EROOT}/usr/share/glib-2.0/schemas"
}
