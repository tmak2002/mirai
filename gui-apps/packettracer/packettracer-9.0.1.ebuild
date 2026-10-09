# Copyright 2026 Nadeŭka <me+oss@nadevko.cc>
# Distributed under the terms of the GNU General Public License v2
EAPI=8

inherit desktop pax-utils unpacker xdg

DESCRIPTION='Cisco PacketTracer'
HOMEPAGE=https://www.netacad.com/cisco-packet-tracer
SRC_URI=CiscoPacketTracer_${PV//./}_Ubuntu_64bit.deb
S="${WORKDIR}"/squashfs-root

LICENSE='Cisco-EULA Cisco-PT Cisco-PT-SEULA'
SLOT=$(ver_cut 1)
KEYWORDS='~amd64'

RESTRICT='bindist fetch strip'

QA_PREBUILT="opt/${PN}-${SLOT}/*"

RDEPEND='
	app-arch/brotli
	app-arch/libdeflate
	app-arch/zstd
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/libinput
	dev-libs/libpcre2[pcre16]
	dev-libs/nspr
	dev-libs/nss
	dev-libs/wayland
	media-libs/fontconfig
	media-libs/harfbuzz
	media-libs/jbigkit
	media-libs/libpng
	media-libs/libpulse
	sys-apps/dbus
	sys-libs/mtdev
	virtual/libudev
	virtual/opengl
	x11-libs/libdrm
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon[X]
	x11-libs/libxkbfile
	x11-libs/libXrandr
	x11-libs/libXtst
	x11-libs/tslib
	x11-libs/xcb-util-cursor
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-renderutil
	x11-libs/xcb-util-wm
'
BDEPEND=dev-util/patchelf

pkg_nofetch() {
	einfo "Please log in & download ${SRC_URI} from:"
	einfo '  https://www.netacad.com/resources/lab-downloads'
	einfo 'and place it into your DISTDIR directory.'
}

src_unpack() {
	unpack_deb "${SRC_URI}"
	./opt/pt/packettracer.AppImage --appimage-extract ||
		die 'Failed to extract packettracer.AppImage'
}

src_prepare() {
	default
	patchelf --replace-needed libjbig.so.0 libjbig.so \
		"${S}"/usr/lib/libtiff.so.5 || die
}

src_install() {
	local PNS=${PN}-${SLOT}

	# /opt
	dodir /opt/${PNS}
	cp -Rp opt/pt/* "${ED}"/opt/${PNS} ||
		die 'Failed to install core files to /opt'
	exeinto /opt/${PNS}/bin
	doexe usr/lib/{libjpeg.so.8,libtiff.so.5}
	rm "${ED}"/opt/${PNS}/{linguist,packettracer} || die

	# bins & wrappers
	cp "${FILESDIR}"/${PNS} "${T}" || die
	sed -e "s|@EPREFIX@|${EPREFIX}|g" -i "${T}"/${PNS} ||
		die "Failed to patch wrapper '${T}/${PNS}'"
	dobin "${T}"/${PNS}

	# desktop
	cp "${FILESDIR}"/${PNS}.desktop "${T}" || die
	sed -e "s|@EPREFIX@|${EPREFIX}|g" -i "${T}"/${PNS}.desktop ||
		die "Failed to patch desktop file '${T}/${PNS}.desktop'"
	domenu "${T}"/${PNS}.desktop

	# icons
	newicon -s 48 opt/pt/art/app.png "${PNS}.png"
	local ext
	for ext in pka pkt pkz pksz; do
		insinto /usr/share/icons/hicolor/48x48/mimetypes
		newins opt/pt/art/${ext}.png application-x-${ext}.png
	done

	# mime
	insinto /usr/share/mime/packages
	doins usr/share/mime/packages/*

	# permissions & security
	pax-mark m "${ED}"/opt/${PNS}/bin/{PacketTracer,QtWebEngineProcess}
}

