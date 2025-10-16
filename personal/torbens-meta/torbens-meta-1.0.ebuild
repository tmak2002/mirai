# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta package for personal use"
LICENSE="metapackage"
SLOT="0"
IUSE="bin"

KEYWORDS="amd64"

RDEPEND="
	app-admin/keepassxc
        net-p2p/syncthing

        bin? (
		www-client/firefox-bin
		mail-client/thunderbird-bin
		app-office/libreoffice-bin
	)
	!bin? (
		www-client/firefox
		mail-client/thunderbird
		app-office/libreoffice
	)
"
