# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Scripts to make kernel upgrades easy"
HOMEPAGE="https://github.com/tmak2002/kernel-deploy"
SRC_URI="
	https://github.com/tmak2002/kernel-deploy/archive/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv x86 ~x64-macos"

