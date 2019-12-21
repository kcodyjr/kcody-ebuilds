# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Intel IXGBE NIC Driver"
HOMEPAGE="https://www.intel.com/content/www/us/en/support/articles/000005688/network-and-i-o/ethernet-products.html"
SRC_URI="https://downloadmirror.intel.com/14687/eng/${P}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND} sys-kernel/dkms"
BDEPEND=""

PATCHES="${FILESDIR}/${PN}-noman.patch"

gen_dkms_conf() {
cat <<EEOF
MAKE="'make' BUILD_KERNEL=\$kernelver"
CLEAN="'make' clean"
PACKAGE_NAME="${PN}"
PACKAGE_VERSION="${PV}"

BUILT_MODULE_NAME[0]="${PN}"
BUILT_MODULE_LOCATION[0]="."
DEST_MODULE_LOCATION[0]="/extra"

AUTOINSTALL="yes"
EEOF
}

src_install() {
	dodoc README
	doman ${PN}.7
	local SRCPATH="/usr/src/${PN}-${PVR}"
	insinto "$SRCPATH"
	doins src/*
	gen_dkms_conf > "${ED}/${SRCPATH}/dkms.conf"
}

pkg_postinst() {
	dkms add -m "${PN}" -v "${PVR}"
	ARCH='' dkms autoinstall
}

pkg_prerm() {
	dkms remove "${PN}/${PVR}" --all
}

