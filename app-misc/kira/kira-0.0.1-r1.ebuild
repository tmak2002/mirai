# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Torben's meta"
HOMEPAGE="https://github.com/tmak2002/mirai"
LICENSE="metapackage"
SLOT="0"
KEYWORDS="amd64"
IUSE="bin"

RDEPEND="
	bin? (
		www-client/firefox-bin
	)
	!bin? (
		www-client/firefox
	)
"
