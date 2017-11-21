# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools linux-info

DESCRIPTION="GFS2 Utilities"
HOMEPAGE="https://pagure.org/gfs2-utils"
SRC_URI="https://releases.pagure.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug udev"

RDEPEND="sys-libs/zlib
	sys-libs/ncurses
	sys-apps/util-linux
	udev? ( sys-fs/lvm2 virtual/udev )"

# util-linux for libuuid and libblkid
# lvm2 for dmsetup

DEPEND="${RDEPEND}
	sys-devel/autoconf
	sys-devel/automake
	sys-devel/libtool
	sys-devel/make
	sys-devel/gettext
	sys-devel/bison
	sys-devel/flex
	sys-kernel/linux-headers
	virtual/pkgconfig"

pkg_pretend() {

	if ! linux_config_exists
	then
		ewarn No kernel config detected. Unable to check options.
	fi

	if ! linux_chkconfig_present GFS2_FS
	then
		ewarn CONFIG_GFS2_FS not set.
		ewarn You will need to enable it to mount GFS2 filesystems.
	fi

}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-helper.patch"
	epatch_user
}

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		--libexecdir=/usr/libexec/gfs2 \
		--with-udevdir=/lib/udev
}

src_compile() {
	emake
}

src_install() {
	default

	# clean up double docs dir
	mv -f ${D}/usr/share/doc/${PN}/* ${D}/usr/share/doc/${P}
	rmdir "${D}/usr/share/doc/${PN}"

	# if we're using udev, fixup helper; if not, lose it
	if use udev
	then
		sed -i 's/usr\/bin\/dmsetup/sbin\/dmsetup/' \
		       "${D}/usr/libexec/gfs2/gfs2_withdraw_helper"
	else
		rm -rf "${D}/lib" "${D}/usr/libexec"
	fi

}
