# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 git-r3

DESCRIPTION="Hiedi — HeDE's local-first, cloud-on-consent project-planning assistant"
HOMEPAGE="https://github.com/k5blazerfl/Hiedi"
EGIT_REPO_URI="https://github.com/k5blazerfl/Hiedi.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""

# pyyaml: the Voyage/Chart/Logbook store (plain YAML+MD on disk).
# pyside6: the summon panel (hiedi). dbus-next: the session daemon (hiedid,
# org.hede.hiedi). The local brain talks to a running Ollama over HTTP (a
# runtime service, not a build dep — see pkg_postinst).
RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/pyside:6[${PYTHON_USEDEP},widgets]
	dev-python/dbus-next[${PYTHON_USEDEP}]
"

# The test suite is the pure core (model/store/brain/agent/bridge) — no Qt, no bus.
distutils_enable_tests pytest

pkg_postinst() {
	elog "Hiedi installed. Three ways in:"
	elog "    hiedi          — the summon panel (Qt)"
	elog "    hiedi-voyage   — the headless CLI (new/draft/show/done/log)"
	elog "    hiedid         — the session daemon (org.hede.hiedi)"
	elog
	elog "The default (local) brain needs a running Ollama at \$OLLAMA_HOST"
	elog "(default http://localhost:11434). The cloud brain (Claude) is wired but"
	elog "disabled in this release; its key will come from HeDE's Keychain."
	elog "Voyages live under ~/Voyages (override with \$HIEDI_VOYAGES)."
}
