# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Intel IXGBE NIC Driver"
HOMEPAGE="https://www.intel.com/content/www/us/en/support/articles/000005688/network-and-i-o/ethernet-products.html"
SRC_URI="https://downloadmirror.intel.com/14687/eng/${P}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+8021p +hwrsc iscsi +lro ptp vfmq"

REQUIRED_USE="?? ( lro iscsi )"

DEPEND=""
RDEPEND="${DEPEND} sys-kernel/dkms"
BDEPEND=""

PATCHES="${FILESDIR}/${PN}-noman.patch"

gen_extra_cflags() {
	local rv
	use 8021p || rv+=" -DIXGBE_DISABLE_8021P_SUPPORT"
	use hwrsc || rv+=" -DIXGBE_NO_HW_RSC"
	use lro   || rv+=" -DIXGBE_NO_LRO"
	use ptp   && rv+=" -DIXGBE_PTP"
	use vfmq  && rv+=" -DIXGBE_ENABLE_VF_MQ"
	echo $rv
}

gen_dkms_conf() {
	local cflags="$(gen_extra_cflags)"
cat <<EEOF
MAKE="'make' BUILD_KERNEL=\$kernelver CFLAGS_EXTRA='$cflags'"
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
	ARCH="$(uname -m)" dkms autoinstall
}

pkg_prerm() {
	dkms remove "${PN}/${PVR}" --all
}

